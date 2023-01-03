local M = {
  "simrat39/symbols-outline.nvim",
  event = "BufReadPre",
}

function M.config()
  require("symbols-outline").setup({
    width = 25,
  })
end

function M.init()
  require("user.functions").registerKeyMap({
    S = {
      CMD "SymbolsOutline",
      "Toggle Symbols Outline",
    },
  })
end

return M
