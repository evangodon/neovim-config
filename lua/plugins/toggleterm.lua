-- Toggleterm
-- https://github.com/akinsho/toggleterm.nvim
--
local M = {
  "akinsho/toggleterm.nvim",
  keys = [[<c-\>]],
}

local utils = require "user.functions.utils"

function M.config()
  local toggleterm = require "toggleterm"

  local border_color = utils.get_color("DiffChange", "fg#")
  local background_color = "#181825"

  toggleterm.setup({
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    shade_terminals = false,
    shading_factor = -100,
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = "curved",
      height = 22,
    },
    highlights = {
      NormalFloat = {
        guibg = background_color,
      },
      FloatBorder = {
        guifg = border_color,
        guibg = background_color,
      },
    },
  })
end

function M.init()
  -- Set terminal keymaps
  vim.api.nvim_create_autocmd({ "TermOpen" }, {
    callback = function()
      local opts = { noremap = true }
      vim.api.nvim_buf_set_keymap(0, "t", "<C-n>", [[<C-\><C-n>]], opts)
    end,
  })

  -- Custom Terminals
  local Terminal = require("toggleterm.terminal").Terminal

  local todoTui = Terminal:new({
    cmd = "todo interactive",
    hidden = true,
  })

  local dailyNote = Terminal:new({
    cmd = "zk daily",
    hidden = true,
  })

  local wk = require "which-key"

  wk.add({
    {
      LeaderKey "to",
      function()
        todoTui:toggle()
      end,
      desc = "Open the todo tui app",
    },
  })

  vim.api.nvim_create_user_command("DailyNote", function()
    dailyNote:toggle()
  end, { nargs = 0 })
end

return M
