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
    shade_terminals = true,
    shading_factor = 2,
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = "curved",
      height = 22,
    },
    highlights = {
      NormalFloat = {
        guibg = termBgColor,
      },
      FloatBorder = {
        -- guibg = termBgColor,
        -- guifg = palette.mauve,
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

  local todo = Terminal:new({
    cmd = "todomd interactive",
    hidden = true,
  })

  local dash = Terminal:new({ cmd = "dash", hidden = true })

  --[[ local lazygit = Terminal:new({ cmd = "lazygit", hidden = true }) ]]
  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "t", function()
    todo:toggle()
  end, opts)

  local fn = require "user.functions"
  fn.registerKeyMap({
    tt = {
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
        CMD [[silent! !kitty @ launch --cwd=current --type=overlay --tab-title="Lazygit" --title="Lazygit" lazygit]],
        "Open [l]azygit",
      },
    },
  })
end

return M
