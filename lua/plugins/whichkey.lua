local M = {
  "folke/which-key.nvim",
  lazy = true,
  event = "VeryLazy",
}

function M.config()
  local wk = require "which-key"
  wk.setup()
end

return M
