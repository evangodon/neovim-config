local M = {
  "ray-x/go.nvim",
  ft = "go",
  dependencies = {
    "ray-x/guihua.lua",
  },
}

function M.config()
  local go = require "go"

  go.setup({
    diagnostic = {
      signs = true,
      virtual_text = false,
    },
  })
end

function M.init()
  local wk = require "which-key"

  vim.api.nvim_create_autocmd("LspAttach", {
    pattern = "*.go",
    callback = function(args)
      local bufnr = args.buf or vim.api.nvim_get_current_buf()

      wk.add({
        { LeaderKey "G", group = "Go" },
        { LeaderKey "Gf", CMD "GoFillStruct", desc = "Fill struct", buffer = bufnr },
        { LeaderKey "Gi", CMD "GoImports", desc = "Go imports", buffer = bufnr },
        { LeaderKey "Ge", CMD "GoIfErr", desc = "Add if err", buffer = bufnr },
        { LeaderKey "Gd", CMD "GoDoc", desc = "Go doc", buffer = bufnr },
        { LeaderKey "Gt", CMD "GoTestFile -v", desc = "Run tests for current file", buffer = bufnr },
      })
    end,
  })
end

return M
