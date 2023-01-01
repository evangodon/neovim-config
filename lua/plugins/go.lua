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
      e = { ":GoIfErr<cr>", "Add err if statement" },
    },
  })
end

return M
