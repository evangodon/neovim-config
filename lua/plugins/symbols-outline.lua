local M = {
  "simrat39/symbols-outline.nvim",
}

function M.config()
  require("symbols-outline").setup({
    width = 25,
  })

  require("user.functions").registerKeyMap({
    S = {
      CMD "SymbolsOutline",
      "Toggle Symbols Outline",
    },
  })
end

return M
