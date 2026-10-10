--- Chezmoi integration.
---
--- Two concerns are handled separately:
---
--- 1. Writing a chezmoi-managed destination file pushes that edit back into the source state with
---    `chezmoi re-add`, so editing the destination directly still ends up in the dotfiles. Files
---    that come from a template cannot be re-added, so they are reported instead.
--- 2. Writing a file inside the chezmoi source directory pushes it out to its destination with
---    `chezmoi apply`.
---
--- The managed-file set and the source directory are fetched once, asynchronously, at setup. Both
--- are then answered from memory, so no subprocess runs per buffer event. Until the caches are
--- warm the checks are skipped rather than blocking startup.

local notify = require "util.notify"

local M = {}

--- Absolute target paths of every file chezmoi manages.
---@type table<string, boolean>
local managed_targets = {}

--- Absolute path of the chezmoi source directory, once known.
---@type string?
local source_dir = nil

--- Source path for a target, cached per target.
---@type table<string, string>
local source_paths = {}

--- Paths already reported as templates, so the warning is not repeated on every save.
---@type table<string, boolean>
local warned = {}

--- Whether a chezmoi command is currently running.
---@type boolean
local busy = false

--- Command to run once the current one finishes.
---@type string[]?
local queued = nil

--- Populate the managed set and source directory without blocking startup.
---
---@return nil
local function warm_up()
  if vim.fn.executable "chezmoi" == 0 then
    return
  end

  vim.system(
    { "chezmoi", "managed", "--path-style", "absolute", "--include", "files,symlinks" },
    { text = true },
    function(result)
      if result.code ~= 0 then
        return
      end

      for line in (result.stdout or ""):gmatch "[^\n]+" do
        managed_targets[vim.fs.normalize(line)] = true
      end
    end
  )

  vim.system({ "chezmoi", "source-path" }, { text = true }, function(result)
    if result.code ~= 0 then
      return
    end

    local value = vim.trim(result.stdout or "")
    if value ~= "" then
      source_dir = vim.fs.normalize(value)
    end
  end)
end

--- Check whether a path is a chezmoi-managed destination file.
---
---@param filepath string
---@return boolean
local function is_managed_target(filepath)
  return managed_targets[vim.fs.normalize(filepath)] == true
end

--- Check whether a path lives inside the chezmoi source directory.
---
---@param filepath string
---@return boolean
local function is_source_file(filepath)
  if not source_dir then
    return false
  end

  return vim.startswith(vim.fs.normalize(filepath), source_dir .. "/")
end

--- Report a failed chezmoi command using its own error text when available.
---
---@param cmd string[]
---@param result vim.SystemCompleted
---@return nil
local function report_failure(cmd, result)
  local detail = vim.trim(result.stderr or "")
  if detail ~= "" then
    notify.error(detail)
  else
    notify.error(table.concat(cmd, " ") .. " failed")
  end
end

--- Run a chezmoi command, then run the queued command if there is one.
---
--- Commands are serialized so that rapid saves never run concurrent chezmoi processes.
---
---@param cmd string[]
---@return nil
local function run(cmd)
  busy = true

  vim.system(cmd, { text = true }, function(result)
    busy = false

    if result.code ~= 0 then
      report_failure(cmd, result)
    end

    local next_cmd = queued
    queued = nil
    if next_cmd then
      run(next_cmd)
    end
  end)
end

--- Run a chezmoi command, queueing it behind any command already in flight.
---
---@param cmd string[]
---@return nil
local function enqueue(cmd)
  if busy then
    queued = cmd
    return
  end

  run(cmd)
end

--- Resolve the source path for a target, caching the result.
---
---@param filepath string
---@param on_done fun(source: string)
---@return nil
local function resolve_source(filepath, on_done)
  local cached = source_paths[filepath]
  if cached ~= nil then
    on_done(cached)
    return
  end

  vim.system({ "chezmoi", "source-path", filepath }, { text = true }, function(result)
    local source = result.code == 0 and vim.trim(result.stdout or "") or ""
    source_paths[filepath] = source
    on_done(source)
  end)
end

--- Push a destination edit back into the source state, or report a template that cannot be synced.
---
---@param filepath string
---@return nil
local function sync_to_source(filepath)
  resolve_source(filepath, function(source)
    if vim.endswith(source, ".tmpl") then
      if warned[filepath] then
        return
      end

      warned[filepath] = true
      notify.warn(string.format("%s is generated from a template and cannot be re-added; edit %s", filepath, source))
      return
    end

    enqueue({ "chezmoi", "re-add", filepath })
  end)
end

--- Push a source file edit out to its destination.
---
---@param filepath string
---@return nil
local function sync_to_target(filepath)
  enqueue({ "chezmoi", "apply", "--force", "--source-path", filepath })
end

--- Route a write to the correct chezmoi command.
---
--- Runs on BufWritePost because both commands read the file from disk.
---
---@return nil
local function on_buf_write_post()
  local filepath = vim.fn.expand "%:p"
  if filepath == "" then
    return
  end

  if is_source_file(filepath) then
    sync_to_target(filepath)
    return
  end

  if is_managed_target(filepath) then
    sync_to_source(filepath)
  end
end

--- Report the current state of the chezmoi integration.
---
--- Useful for diagnosing why a write did not sync. A managed target count of zero means the
--- startup lookup has not finished or failed.
---
---@return table<string, any>
function M.status()
  local filepath = vim.fn.expand "%:p"

  local managed_count = 0
  for _ in pairs(managed_targets) do
    managed_count = managed_count + 1
  end

  return {
    executable = vim.fn.executable "chezmoi" == 1,
    managed_targets = managed_count,
    source_dir = source_dir or "(not resolved)",
    current_file = filepath ~= "" and filepath or "(none)",
    current_is_managed_target = filepath ~= "" and is_managed_target(filepath) or false,
    current_is_source_file = filepath ~= "" and is_source_file(filepath) or false,
    cached_source_paths = vim.tbl_count(source_paths),
    busy = busy,
    queued = queued and table.concat(queued, " ") or "(none)",
  }
end

--- Register the chezmoi autocommand group and warm the caches.
---
---@return nil
function M.setup()
  local group = vim.api.nvim_create_augroup("chezmoi", { clear = true })

  vim.api.nvim_create_autocmd("BufWritePost", {
    desc = "Sync chezmoi source and destination files after a write",
    group = group,
    pattern = "*",
    callback = on_buf_write_post,
  })

  vim.api.nvim_create_user_command("ChezmoiStatus", function()
    notify.inspect(M.status())
  end, { desc = "Show chezmoi integration status" })

  warm_up()
end

return M
