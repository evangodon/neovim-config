-- Snacks

local M = {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
}

function M.config()
  local snacks = require "snacks"

  snacks.setup({
    ---@type snacks.Config
    opts = {},
  })
end

return M
