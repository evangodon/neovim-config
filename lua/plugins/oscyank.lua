local M = {
  "ojroques/vim-oscyank",
  branch = "main",
  event = "VeryLazy",
  cmd = { "OSCYankReg" },
}

-- TODO: replace with https://github.com/ojroques/nvim-osc52
function M.config()
  -- Use OSCYANK to copy visual selection to system clipboard
  local function setToSystemClipboard()
    local register = "o"

    -- set to register
    vim.cmd(string.format('noautocmd normal! "%sy', register))

    -- use Oscyank to set to clipboard
    vim.cmd("OSCYankReg " .. register)

    -- Show what was copied
    local copied = vim.fn.getreg(register)
    Notify.info(copied)
  end

  local keymap_desc = "Copy visual selection to system clipboard"
  vim.keymap.set("x", "Y", setToSystemClipboard, { desc = keymap_desc })
  vim.keymap.set("x", "<C-c>", setToSystemClipboard, { desc = keymap_desc })
end

return M
