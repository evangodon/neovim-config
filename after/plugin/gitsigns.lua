-- Gitsigns
-- https://github.com/lewis6991/gitsigns.nvim

local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
  Notify.error "Gitsigns failed to load"
  return
end

local gitsign_icon = "▒"
local gitsign_icon_delete = "-"

gitsigns.setup({
  signs = {
    add = { hl = "GitSignsAdd", text = gitsign_icon, numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = {
      hl = "GitSignsChange",
      text = gitsign_icon,
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
    delete = {
      hl = "GitSignsDelete",
      text = gitsign_icon_delete,
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    topdelete = {
      hl = "GitSignsDelete",
      text = gitsign_icon_delete,
      numhl = "GitSignsDeleteNr",
      linehl = "GitSignsDeleteLn",
    },
    changedelete = {
      hl = "GitSignsChange",
      text = gitsign_icon,
      numhl = "GitSignsChangeNr",
      linehl = "GitSignsChangeLn",
    },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter_opts = {
    relative_time = false,
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  yadm = {
    enable = false,
  },
  on_attach = function(bufnr)
    local fn = require "user.functions"
    local gs = package.loaded.gitsigns

    local function keymap(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    keymap("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true, desc = "Next hunk" })

    keymap("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true, desc = "Previous hunk" })

    -- Actions
    fn.leaderKeymaps({
      G = {
        name = "Git",
        s = {
          gs.toggle_signs,
          "Toggle signs",
        },
        P = { gs.preview_hunk, "Preview hunk" },
        b = {
          gs.toggle_current_line_blame,
          "Toggle blame",
        },
        R = {
          ":Gitsigns reset_hunk<CR>",
          "Reset hunk",
        },
        d = {
          gs.diffthis,
          "Diff agaist the index",
        },
        D = {
          function()
            gs.diffthis "~"
          end,
          "Diff against ~",
        },
      },
    })
  end,
})