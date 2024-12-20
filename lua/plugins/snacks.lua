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
    opts = {
      notify = true,
      notifier = { style = "compact" },
    },
  })

  local wk = require "which-key"
  wk.add({
    { LeaderKey "N", snacks.notifier.show_history, desc = "See Notifications" },
  })
end

return M
