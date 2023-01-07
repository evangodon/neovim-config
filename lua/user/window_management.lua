--
-- Dim inactive windows
--

local utils = require "user.functions.utils"

local function set_window_colors()
  vim.cmd [[
    highlight! clear ActiveWindow
    highlight! clear InactiveWindow
    highlight! clear SignColumn
    highlight! clear CursorLineSign
  ]]
  vim.api.nvim_set_hl(0, "ActiveWindow", { bg = utils.get_color("Normal", "bg#"), fg = "NONE" })
  vim.api.nvim_set_hl(0, "InactiveWindow", { bg = utils.get_color("NormalFloat", "bg#"), fg = "NONE" })

  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE", fg = "NONE" })
  vim.api.nvim_set_hl(0, "CursorLineSign", { bg = "NONE", fg = "NONE" })
end

set_window_colors()

local function getWinHighlight(highlights)
  local default_win_highlights = {
    Normal = "ActiveWindow",
    NormalNC = "InactiveWindow",
  }
  local win_highlights = vim.tbl_extend("force", default_win_highlights, highlights)

  local winhl_list = {}
  for key, value in pairs(win_highlights) do
    local highlight_link = string.format("%s:%s", key, value)
    table.insert(winhl_list, highlight_link)
  end

  local winhl_str = table.concat(winhl_list, ",")
  return winhl_str
end

vim.opt_local.winhighlight = getWinHighlight({ SignColumn = "ActiveWindow" })

local wm_group = vim.api.nvim_create_augroup("WindowManagement", {})

vim.api.nvim_create_autocmd({ "WinEnter" }, {
  group = wm_group,
  callback = function()
    local ft = vim.bo.filetype
    local in_nvim_tree = ft == "NvimTree"

    local win_highlights = {}

    if in_nvim_tree then
      win_highlights["CursorLine"] = "NvimTreeCursorLine"
    end

    vim.opt_local.winhighlight = getWinHighlight(win_highlights)
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave" }, {
  group = wm_group,
  callback = function()
    local ft = vim.bo.filetype
    local in_nvim_tree = ft == "NvimTree"

    local win_highlights = {}

    if in_nvim_tree then
      win_highlights["CursorLine"] = "NvimTreeCursorLineNC"
    end

    vim.opt_local.winhighlight = getWinHighlight(win_highlights)
  end,
})

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  group = wm_group,
  callback = function()
    set_window_colors()
  end,
})
