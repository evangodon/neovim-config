local backslash = [[\]]
local jump_leader = "<leader>j"

local M = {
  "cbochs/grapple.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "folke/which-key.nvim" },
  keys = { backslash, jump_leader },
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
      resession = false,
    },
  })
end

function M.init()
  local grapple = require "grapple"
  local whichkey = require "which-key"

  vim.keymap.set("n", "<leader>J", function()
    grapple.toggle()
    local bufnr = vim.api.nvim_get_current_buf()
    local bufpath = vim.api.nvim_buf_get_name(bufnr)
    local bufname = vim.fn.fnamemodify(bufpath, ":t")

    if grapple.exists() then
      Notify.info("Added tag to " .. bufname)
    else
      Notify.info("Remove tag from " .. bufname)
    end
  end, { noremap = true, silent = true })

  whichkey.register({
    [backslash] = {
      function()
        grapple.toggle_tags()
        CMD "redrawtabline"
      end,
      "View tags",
    },
    ["]"] = {
      grapple.cycle_forward,
      "Cycle forward",
    },
    ["["] = {
      grapple.cycle_backward,
      "Cycle back",
    },
  }, {
    prefix = backslash,
    mode = "n",
  })
end

return M
