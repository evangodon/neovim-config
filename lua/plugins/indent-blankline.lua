local M = {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufReadPre",
}

function M.config()
  local indent_blankline = require "indent_blankline"

  indent_blankline.setup({
    show_current_context = false,
    show_current_context_start = true,
  })
end

return M
