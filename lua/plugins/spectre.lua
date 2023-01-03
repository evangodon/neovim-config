local M = {
  "windwp/nvim-spectre",
}

function M.init()
  local fn = require "user.functions"
  local spectre = require "spectre"

  fn.registerKeyMap({
    s = {
      name = "Spectre",
      o = {
        function()
          spectre.open()
        end,
        "Open [s]prectre",
      },
    },
  })
end

return M
