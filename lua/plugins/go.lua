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
end

function M.init()
  local fn = require "user.functions"

  fn.registerKeyMap({
    g = {
      name = "Go",
      f = { ":GoFillStruct<cr>", "Fill struct" },
      i = { ":GoImport<cr>", "Go imports" },
      g = { ":GoFmt<cr>", "Format" },
      e = { ":GoIfErr<cr>", "Add err if" },
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
end

return M
