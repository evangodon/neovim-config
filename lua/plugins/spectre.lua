local M = {
  "windwp/nvim-spectre",
}

function M.config()
  local spectre = require "spectre"
  spectre.setup({
    is_insert_mode = false,
    live_update = true,
    highlight = {
      ui = "String",
      search = "DiffChange",
      replace = "DiffAdd",
    },
    mapping = {
      close = {
        map = "<leader>so",
        cmd = CMD "close",
        desc = "Close",
      },
    },
  })
end

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
