--- Open files and lines in GitHub
local M = {
  "almo7aya/openingh.nvim",
  event = { "VeryLazy" },
  enabled = true,
}

function M.config()
  local util = require "user.functions.utils"

  util.keymap("n", LeaderKey "gO", CMD "OpenInGHFile", "Open file in Github")
  util.keymap("v", LeaderKey "gO", CMD "OpenInGHFileLines", "Open lines in Github")

  util.keymap("n", LeaderKey "go", CMD "OpenInGHFile+", "Copy Github link to clipboard")
  util.keymap("v", LeaderKey "go", CMD "OpenInGHFileLines+", "Copy Github link to clipboard")
end

return M
