--- Floating window helper for running a CLI command with visible output.

local M = {}

--- Open a floating terminal window running the given command.
---
---@param cmd string Command to run in the terminal.
---@param on_open? fun(buf: integer) Called with the terminal buffer after it is created.
---@return nil
function M.with_output_from(cmd, on_open)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  })

  vim.fn.jobstart(cmd, {
    term = true,
    on_exit = function() end,
  })

  ---@return nil
  local function close_window()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  local keymap_options = { buffer = buf, noremap = true, silent = true }
  vim.keymap.set("n", "q", close_window, keymap_options)
  vim.keymap.set("n", "<Esc>", close_window, keymap_options)

  if on_open and type(on_open) == "function" then
    on_open(buf)
  end
end

return M
