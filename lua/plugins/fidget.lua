local M = {
  "j-hui/fidget.nvim",
  event = "LspAttach",
  tag = "legacy",
}

function M.config()
  local fidget = require "fidget"

  fidget.setup({
    text = {
      spinner = "dots_pulse",
      done = "DONE",
    },
  })
end

return M
