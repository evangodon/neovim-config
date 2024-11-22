local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
}

function M.config()
  local wk = require "which-key"
  wk.setup({
    preset = "modern",
    plugins = {
      marks = false, -- Disable marks since it doesn't respect timeoutlen
      spelling = {
        enabled = true,
        suggestions = 20,
      },
    },
    win = {
      padding = { 1, 1 }, -- extra window padding [top/bottom, right/left]
      title = false,
      title_pos = "center",
      zindex = 1000,
      bo = {},
      wo = {},
    },
  })
end

return M
