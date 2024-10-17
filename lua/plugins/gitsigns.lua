-- Gitsigns
-- https://github.com/lewis6991/gitsigns.nvim
--
local M = {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
}

function M.config()
  local gitsigns = require "gitsigns"
  local kitty = require "user.functions.kitty"

  local gitsign_icon = "│"
  local gitsign_icon_delete = "-"
  local gitsign_icon_top_delete = "‾"
  local gitsign_untracked = "┆"

  gitsigns.setup({
    signs = {
      add = { text = gitsign_icon },
      change = { text = gitsign_icon },
      delete = { text = gitsign_icon_delete },
      topdelete = { text = gitsign_icon_top_delete },
      changedelete = { text = gitsign_icon },
      untracked = { text = gitsign_untracked },
    },
    signs_staged = {
      add = { text = gitsign_icon },
      change = { text = gitsign_icon },
      delete = { text = gitsign_icon_delete },
      topdelete = { text = gitsign_icon_top_delete },
      changedelete = { text = gitsign_icon },
      untracked = { text = gitsign_untracked },
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
      fn.register_key_map({
        g = {
          name = "Git",
          p = { gs.preview_hunk, "Preview hunk" },
          b = {
            gs.toggle_current_line_blame,
            "Toggle blame",
          },
          r = {
            ":Gitsigns reset_hunk<CR>",
            "Reset hunk",
          },
          d = {
            CMD "DiffviewOpen",
            "Open diff view",
          },
          D = {
            function()
              gs.diffthis "~"
            end,
            "Diff against ~",
          },
          l = {
            function()
              kitty.launch({ program = "lazygit" })
            end,
            "Open Lazygit",
          },
        },
      })
    end,
  })
end

return M
