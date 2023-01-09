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
      width = 100,
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
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "q", CMD "close", opts)
    end,
    on_close = function()
      vim.cmd [[ScrollbarShow]]
      vim.keymap.set("n", "q", "<Nop>")
    end,
  })
end

function M.init()
  local fn = require "user.functions"
  fn.register_key_map({
    Z = {
      ":noautocmd ZenMode<CR>",
      "Zen Mode",
    },
  })
end

return M
