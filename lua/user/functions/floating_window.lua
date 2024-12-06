local M = {}

-- Function to open a floating window with CLI tool output
---@param cmd string
---@param on_open? fun(buf: integer)
function M.with_output_from(cmd, on_open)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  })

  -- Run the command in the buffer with terminal emulation
  vim.fn.termopen(cmd, {
    on_exit = function() end,
  })

  local function close_window()
    vim.api.nvim_win_close(win, true)
  end
  local keymap_options = { buffer = buf, noremap = true, silent = true }
  -- Add a keymap to close the floating window
  vim.keymap.set("n", "q", close_window, keymap_options)
  vim.keymap.set("n", "<ESC>", close_window, keymap_options)

  vim.bo[buf].modifiable = false

  if on_open and type(on_open) == "function" then
    on_open(buf)
  end
end

return M
