-- Zen-mode
-- https://github.com/folke/zen-mode.nvim
--
local M = {
  "folke/zen-mode.nvim",
  cmd = { "ZenMode" },
}

function M.config()
  local zenmode = require "zen-mode"

  local kitty_font_group_id = vim.api.nvim_create_augroup("KittyFontReset", { clear = true })

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
      vim.fn.system "kitty @ set-font-size +2"

      vim.keymap.set("n", "q", Cmd "close", { noremap = true, silent = true })
      vim.api.nvim_create_autocmd("VimLeavePre", {
        group = kitty_font_group_id,
        callback = function()
          vim.fn.system "kitty @ set-font-size 0"
        end,
        desc = "Reset Kitty font size when exiting Neovim",
      })
    end,
    on_close = function()
      vim.cmd [[
        ScrollbarShow
        Gitsigns toggle_signs true
      ]]

      vim.fn.system "kitty @ set-font-size 0"
      vim.keymap.set("n", "q", "<Nop>")
      vim.api.nvim_clear_autocmds({ group = kitty_font_group_id })
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
