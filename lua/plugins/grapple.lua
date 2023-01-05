local backslash = [[\]]

local M = {
  "cbochs/grapple.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = backslash,
}

function M.config()
  require("grapple").setup({
    log_level = "warn",
    scope = "git",
    popup_options = {
      relative = "editor",
      width = 60,
      height = 12,
      style = "minimal",
      focusable = false,
      border = "single",
    },

    integrations = {
      ---Support for saving tag state using resession.nvim
      resession = false,
    },
  })
end

-- TODO: add keymaps with letters
-- TODO: Get all tags and show kepmaps for active tags
-- TODO: Show tag next to buffer name
function M.init()
  local grapple = require "grapple"
  local keymap = vim.keymap.set

  local function set_opts(desc)
    return { noremap = true, silent = true, desc = desc }
  end

  keymap("n", backslash .. "=", grapple.tag, set_opts "Tag")
  keymap("n", backslash .. "-", grapple.untag, set_opts "Untag")
  keymap("n", backslash .. backslash, grapple.popup_tags, set_opts "Popup Tags")
  keymap("n", backslash .. "]", grapple.cycle_forward, set_opts "Cycle Forward")
  keymap("n", backslash .. "[", grapple.cycle_forward, set_opts "Cycle Back")
  for i = 5, 1, -1 do
    local num = tostring(i)
    keymap("n", backslash .. num, function()
      grapple.select({ key = i })
    end, set_opts("Select" .. num))
  end
end

return M
