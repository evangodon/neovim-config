local M = {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  priority = 1000,
}

M.config = function()
  require("tiny-inline-diagnostic").setup({
    preset = "nonerdfont",
  })
end

return M
