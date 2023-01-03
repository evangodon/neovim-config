local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
}

function M.config()
  local wk = require "which-key"
  wk.setup()
end

return M
