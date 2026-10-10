--- Notifications for the whole configuration.
---
--- Prefers `Snacks.notify` when the snacks plugin is loaded, and falls back to `vim.notify`
--- otherwise. This keeps the plugin dependency in one place so no other module inherits it.

local M = {}

---@alias UtilNotifyLevel "debug"|"info"|"warn"|"error"

---@type table<UtilNotifyLevel, integer>
local levels = {
  debug = vim.log.levels.DEBUG,
  info = vim.log.levels.INFO,
  warn = vim.log.levels.WARN,
  error = vim.log.levels.ERROR,
}

--- Return the snacks notifier when it is available.
---
--- The plugin may only be reachable through its global table, because it can be loaded before
--- `require` resolves it, so both are checked.
---
---@return table|nil
local function resolve_snacks()
  local global = rawget(_G, "Snacks")
  if type(global) == "table" and type(global.notify) == "table" then
    return global.notify
  end

  local ok, module = pcall(require, "snacks")
  if ok and type(module) == "table" and type(module.notify) == "table" then
    return module.notify
  end

  return nil
end

--- Send a notification at the given level.
---
---@param level UtilNotifyLevel
---@param message string
---@param opts? table
---@return nil
function M.notify(level, message, opts)
  local snacks = resolve_snacks()
  if snacks then
    local handler = snacks[level]
    if type(handler) == "function" then
      handler(message, opts)
      return
    end
  end

  vim.notify(message, levels[level], opts)
end

---@param message string
---@param opts? table
---@return nil
function M.debug(message, opts)
  M.notify("debug", message, opts)
end

---@param message string
---@param opts? table
---@return nil
function M.info(message, opts)
  M.notify("info", message, opts)
end

---@param message string
---@param opts? table
---@return nil
function M.warn(message, opts)
  M.notify("warn", message, opts)
end

---@param message string
---@param opts? table
---@return nil
function M.error(message, opts)
  M.notify("error", message, opts)
end

--- Pretty-print any value at info level. Replaces the old global `P` helper.
---
---@param value any
---@return nil
function M.inspect(value)
  M.info(vim.inspect(value))
end

return M
