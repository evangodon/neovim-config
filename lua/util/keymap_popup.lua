--- Dependency-free popup that lists every keymap starting with the leader key.
---
--- Entries are collected at invocation time, so mappings defined by plugins that load later are
--- still included. The popup uses only Neovim APIs.

local M = {}

---@class KeymapPopupEntry
---@field lhs string Left-hand side of the mapping, in :map-compatible form.
---@field rhs string Right-hand side of the mapping.
---@field desc string Mapping description, or an empty string when none is set.
---@field modes string[] Modes the mapping applies to.

---@type table<string, string>
local mode_labels = {
  n = "n",
  v = "v",
  x = "x",
  s = "s",
  o = "o",
  i = "i",
  t = "t",
}

---@type string[]
local scanned_modes = { "n", "v", "x", "s", "o", "i", "t" }

--- Return the configured leader key as a literal string.
---
---@return string
local function get_leader()
  local leader = vim.g.mapleader

  if type(leader) ~= "string" or leader == "" then
    return "\\"
  end

  if leader == "<Space>" then
    return " "
  end

  return vim.api.nvim_replace_termcodes(leader, true, false, true)
end

--- Replace the leading leader key with a readable `<Leader>` marker.
---
---@param lhs string
---@param leader string
---@return string
local function format_lhs(lhs, leader)
  if leader ~= "" and vim.startswith(lhs, leader) then
    return "<Leader>" .. lhs:sub(#leader + 1)
  end

  return lhs
end

---@param mapping vim.api.keyset.get_keymap
---@param leader string
---@return KeymapPopupEntry|nil
local function to_entry(mapping, leader)
  local lhs = mapping.lhs

  if type(lhs) ~= "string" or lhs == "" or lhs == leader then
    return nil
  end

  if not vim.startswith(lhs, leader) then
    return nil
  end

  local mode = type(mapping.mode) == "string" and mapping.mode or "n"

  return {
    lhs = format_lhs(lhs, leader),
    rhs = type(mapping.rhs) == "string" and mapping.rhs or "",
    desc = mapping.desc or "",
    modes = { mode },
  }
end

--- Collect all global and buffer-local leader mappings.
---
--- Mappings are keyed by their displayed left-hand side. Scanning overlapping modes such as
--- visual, select, and exclusive-visual returns the same mapping repeatedly, so modes are merged
--- and deduplicated.
---
---@return KeymapPopupEntry[]
local function collect_entries()
  local leader = get_leader()
  local entries = {}
  ---@type table<string, KeymapPopupEntry>
  local by_lhs = {}

  for _, mode in ipairs(scanned_modes) do
    local mappings = vim.api.nvim_get_keymap(mode)
    vim.list_extend(mappings, vim.api.nvim_buf_get_keymap(0, mode))

    for _, mapping in ipairs(mappings) do
      local entry = to_entry(mapping, leader)
      if entry then
        local existing = by_lhs[entry.lhs]
        if existing then
          if not vim.tbl_contains(existing.modes, entry.modes[1]) then
            table.insert(existing.modes, entry.modes[1])
          end
          if existing.desc == "" and entry.desc ~= "" then
            existing.desc = entry.desc
          end
        else
          by_lhs[entry.lhs] = entry
          table.insert(entries, entry)
        end
      end
    end
  end

  ---@param a string
  ---@param b string
  ---@return boolean
  local function mode_order(a, b)
    return (vim.fn.index(scanned_modes, a) < vim.fn.index(scanned_modes, b))
  end

  for _, entry in ipairs(entries) do
    table.sort(entry.modes, mode_order)
  end

  table.sort(entries, function(a, b)
    return a.lhs < b.lhs
  end)

  return entries
end

--- Render entries as aligned display lines.
---
---@param entries KeymapPopupEntry[]
---@return string[]
local function render(entries)
  local lhs_width = #"Mapping"
  local mode_width = #"Mode"

  for _, entry in ipairs(entries) do
    lhs_width = math.max(lhs_width, #entry.lhs)
    mode_width = math.max(mode_width, #table.concat(entry.modes, ""))
  end

  ---@type string[]
  local lines = {}
  local header = string.format("%-" .. lhs_width .. "s  %-" .. mode_width .. "s  %s", "Mapping", "Mode", "Description")
  table.insert(lines, header)
  table.insert(lines, string.rep("-", #header))

  for _, entry in ipairs(entries) do
    local modes = {}
    for _, mode in ipairs(entry.modes) do
      table.insert(modes, mode_labels[mode] or mode)
    end

    local description = entry.desc
    if description == "" then
      description = entry.rhs ~= "" and entry.rhs or "(no description)"
    end

    table.insert(
      lines,
      string.format(
        "%-" .. lhs_width .. "s  %-" .. mode_width .. "s  %s",
        entry.lhs,
        table.concat(modes, ""),
        description
      )
    )
  end

  return lines
end

--- Open a floating window displaying the provided lines.
---
---@param lines string[]
---@return integer buffer Buffer handle of the popup.
---@return integer window Window handle of the popup.
local function open_float(lines)
  local buffer = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
  vim.bo[buffer].modifiable = false
  vim.bo[buffer].bufhidden = "wipe"
  vim.bo[buffer].filetype = "keymappopup"

  local width = 0
  for _, line in ipairs(lines) do
    width = math.max(width, #line)
  end

  local max_height = math.max(1, vim.o.lines - 4)
  local height = math.min(#lines, max_height)
  width = math.min(width, math.max(20, vim.o.columns - 4))

  local window = vim.api.nvim_open_win(buffer, true, {
    relative = "editor",
    style = "minimal",
    border = "single",
    title = " Leader mappings ",
    title_pos = "center",
    width = width,
    height = height,
    row = math.max(0, math.floor((vim.o.lines - height) / 2) - 1),
    col = math.max(0, math.floor((vim.o.columns - width) / 2)),
  })

  vim.wo[window].wrap = false
  vim.wo[window].cursorline = true

  ---@return nil
  local function close()
    if vim.api.nvim_win_is_valid(window) then
      vim.api.nvim_win_close(window, true)
    end
  end

  vim.keymap.set("n", "q", close, { buffer = buffer, silent = true, desc = "Close leader mappings" })
  vim.keymap.set("n", "<Esc>", close, { buffer = buffer, silent = true, desc = "Close leader mappings" })

  return buffer, window
end

--- Show all mappings that begin with the configured leader key.
---
---@return nil
function M.open()
  local entries = collect_entries()

  if #entries == 0 then
    vim.notify("No leader mappings are defined", vim.log.levels.INFO)
    return
  end

  open_float(render(entries))
end

return M
