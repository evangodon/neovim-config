-- Nvim tree
-- https://github.com/kyazdani42/nvim-tree.lua
-- each of these are documented in `:help nvim-tree.OPTION_NAME`

local M = {
  "kyazdani42/nvim-tree.lua",
}

local fn = require "user.functions"

function M.config()
  local nvim_tree = require "nvim-tree"

  local nvim_tree_config = require "nvim-tree.config"

  local tree_cb = nvim_tree_config.nvim_tree_callback

  NvimTreeWidth = 40

  local icon = {
    diagnostics = "•",
  }

  nvim_tree.setup({
    disable_netrw = true,
    hijack_netrw = true,
    open_on_setup = false,
    ignore_ft_on_setup = {
      "startify",
      "dashboard",
      "alpha",
    },
    open_on_tab = false,
    hijack_cursor = false,
    update_cwd = true,
    filters = {
      custom = { ".git" },
      exclude = { ".gitignore" },
    },
    diagnostics = {
      enable = true,
      icons = {
        hint = icon.diagnostics,
        info = icon.diagnostics,
        warning = icon.diagnostics,
        error = icon.diagnostics,
      },
    },
    update_focused_file = {
      enable = true,
      update_cwd = true,
      ignore_list = {},
    },
    git = {
      enable = true,
      ignore = true,
      timeout = 500,
    },
    actions = {
      open_file = {
        quit_on_open = false,
        window_picker = {
          enable = false,
        },
      },
      change_dir = {
        enable = false,
        restrict_above_cwd = true,
      },
    },
    view = {
      width = NvimTreeWidth,
      centralize_selection = false,
      hide_root_folder = false,
      side = "left",
      mappings = {
        custom_only = false,
        list = {
          { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
          { key = "h", cb = tree_cb "close_node" },
          { key = "v", cb = tree_cb "vsplit" },
          { key = "<C-t>", action = "" },
        },
      },
      number = false,
      relativenumber = false,
    },
    renderer = {
      root_folder_modifier = ":t",
      icons = {
        git_placement = "before",
        padding = " ",
        glyphs = {
          default = "",
          symlink = "",
          git = {
            unstaged = "u",
            staged = "S",
            unmerged = "",
            renamed = "➜",
            deleted = "",
            untracked = "U",
            ignored = "◌",
          },
          folder = {
            default = "  ",
            open = "  ",
            empty = " ",
            empty_open = "  ",
            symlink = "",
          },
        },
      },
    },
  })

  -- Need to call noautocmd before this function
  vim.api.nvim_create_user_command("CustomNvimTreeToggle", function()
    nvim_tree.toggle(false, false)
  end, {})

  fn.registerKeyMap({
    e = {
      function()
        vim.cmd [[CustomNvimTreeToggle]]
      end,
      "Toggle Nvimtree",
    },
    E = {
      CMD "NvimTreeFocus",
      "Focus Nvimtree",
    },
  })
end

return M
