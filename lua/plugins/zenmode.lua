-- Zen-mode
-- https://github.com/folke/zen-mode.nvim
--
local M = {
  "folke/zen-mode.nvim",
  cmd = { "ZenMode" },
}

function M.config()
  local zenmode = require "zen-mode"

  zenmode.setup({
    window = {
      backdrop = 1,
      width = 120,
      height = 30,
    },
    plugins = {
      gitsigns = { enabled = false },
      kitty = {
        enabled = false,
        font = "+4",
      },
    },
    on_open = function()
      vim.cmd [[
        ScrollbarHide
        Gitsigns toggle_signs false
		]]
      vim.keymap.set("n", "q", CMD "close", { noremap = true, silent = true })
    end,
    on_close = function()
      vim.cmd [[
        ScrollbarShow
        Gitsigns toggle_signs true
      ]]
      vim.keymap.set("n", "q", "<Nop>")
    end,
  })
end

function M.init()
  local wk = require "which-key"
  wk.add({
    { LeaderKey "Z", ":noautocmd ZenMode<CR>", desc = "Enable Zen Mode" },
  })
end

return M
