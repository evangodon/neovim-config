local M = {
  "MagicDuck/grug-far.nvim",
  cmd = { "GrugFar" },
}

M.config = function()
  require("grug-far").setup({

    keymaps = { close = { n = "q" }, replace = { n = "R" } },
  })
end

M.init = function()
  local wk = require "which-key"
  local grug = require "grug-far"

  local function open_grug_with_current_word()
    grug.open({ prefills = { search = vim.fn.expand "<cword>" } })
  end

  wk.add({
    { LeaderKey "f", group = "Find" },
    { LeaderKey "fr", grug.open, desc = "Open find and replace" },
    {
      LeaderKey "fw",
      open_grug_with_current_word,
      desc = "Open find and replace with current word",
      mode = "v",
    },
  })
end

return M
