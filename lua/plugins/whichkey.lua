local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
}

function M.config()
  local wk = require "which-key"
  wk.setup({
    plugins = {
      spelling = {
        enabled = true,
        suggestions = 20,
      },
    },
  })
end

return M
