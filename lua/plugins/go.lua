local M = {
  "ray-x/go.nvim",
  ft = "go",
  dependencies = {
    "ray-x/guihua.lua",
  },
}

function M.config()
  local go = require "go"

  go.setup()

  local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
      require("go.format").goimport()
    end,
    group = format_sync_grp,
  })
end

function M.init()
  local fn = require "user.functions"

  vim.api.nvim_create_autocmd("LspAttach", {
    pattern = "*.go",
    callback = function(args)
      local bufnr = args.buf or vim.api.nvim_get_current_buf()
      fn.register_key_map({
        G = {
          name = "Go",
          buffer = bufnr,
          f = { CMD "GoFillStruct", "Fill struct" },
          d = { CMD "GoDoc", "Go doc" },
          i = { CMD "GoImport", "Go imports" },
          g = { CMD "GoFmt", "Format" },
          e = { CMD "GoIfErr", "Add err if" },
          t = {
            CMD "GoTestFile -v",
            "Run tests for current File",
          },
          T = {
            CMD "GoTestPkg -v",
            "Run tests for current package",
          },
          a = {
            CMD "GoAlt!",
            "Switch between go and test file",
          },
          A = {
            CMD "GoAddTest",
            "Add test for current func",
          },
        },
      })
    end,
  })
end

return M
