-- Toggleterm
-- https://github.com/akinsho/toggleterm.nvim
--
local M = {
  "akinsho/toggleterm.nvim",
  keys = [[<c-\>]],
}

function M.config()
  local toggleterm = require "toggleterm"

  local palette = require "catppuccin.palettes.mocha"
  local termBgColor = palette.base

  toggleterm.setup({
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = "curved",
    },
    highlights = {
      NormalFloat = {
        guibg = termBgColor,
      },
      FloatBorder = {
        guibg = termBgColor,
        guifg = palette.mauve,
      },
    },
  })
end

function M.init()
  -- Set terminal keymaps
  vim.api.nvim_create_autocmd({ "TermOpen" }, {
    callback = function()
      local opts = { noremap = true }
      vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
    end,
  })

  -- Custom Terminals
  local Terminal = require("toggleterm.terminal").Terminal

  local todo = Terminal:new({ cmd = "todo interactive", close_on_exit = true })

  local dash = Terminal:new({ cmd = "dash", hidden = true })

  local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

  local fn = require "user.functions"
  fn.registerKeyMap({
    t = {
      function()
        todo:toggle()
      end,
      "Open [t]odo tui",
    },
    D = {
      function()
        dash:toggle()
      end,
      "Open [D]ashboard",
    },
    G = {
      l = {
        function()
          lazygit:toggle()
        end,
        "Open [l]azygit",
      },
    },
  })
end

return M
