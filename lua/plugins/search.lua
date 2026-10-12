-- Telescope, with native fzf sorting. Mappings live here so the plugin loads on first use.

---@return nil
local function find_files()
  require("telescope.builtin").find_files()
end

---@return nil
local function live_grep()
  require("telescope.builtin").live_grep()
end

---@return nil
local function buffer_fuzzy_find()
  require("telescope.builtin").current_buffer_fuzzy_find()
end

---@return nil
local function oldfiles()
  require("telescope.builtin").oldfiles()
end

---@return nil
local function resume()
  require("telescope.builtin").resume()
end

---@return nil
local function diagnostics()
  require("telescope.builtin").diagnostics()
end

---@return nil
local function marks()
  require("telescope.builtin").marks()
end

---@return nil
local function colorscheme()
  require("telescope.builtin").colorscheme({ enable_preview = true })
end

local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  cmd = "Telescope",
  keys = {
    { "<C-p>", find_files, desc = "Find files" },
    { "<C-t>", live_grep, desc = "Grep files" },
    { "<C-f>", buffer_fuzzy_find, desc = "Fuzzy find current buffer" },
    { "<leader>r", oldfiles, desc = "View recent files" },
    { "<leader>R", resume, desc = "Resume last search" },
    { "<leader>d", diagnostics, desc = "View diagnostics" },
    { "<leader>'", marks, desc = "View marks" },
    { "<leader>C", colorscheme, desc = "View colorschemes" },
  },
}

---@return nil
function M.config()
  local telescope = require "telescope"
  local actions = require "telescope.actions"
  local action_layout = require "telescope.actions.layout"

  telescope.setup({
    defaults = {
      prompt_prefix = "  ",
      selection_caret = "█ ",
      path_display = { "truncate" },
      sorting_strategy = "ascending",
      layout_config = {
        horizontal = { prompt_position = "top" },
      },
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
          ["<C-c>"] = actions.close,
          ["<CR>"] = actions.select_default,
          ["<C-x>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-t>"] = actions.select_tab,
          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down,
          ["<M-p>"] = action_layout.toggle_preview,
          ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
          ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          ["<C-l>"] = actions.complete_tag,
          ["<C-_>"] = actions.which_key,
        },
        n = {
          ["<esc>"] = actions.close,
          ["<CR>"] = actions.select_default,
          ["<C-x>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-t>"] = actions.select_tab,
          ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
          ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          ["j"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,
          ["H"] = actions.move_to_top,
          ["M"] = actions.move_to_middle,
          ["L"] = actions.move_to_bottom,
          ["gg"] = actions.move_to_top,
          ["G"] = actions.move_to_bottom,
          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down,
          ["?"] = actions.which_key,
        },
      },
    },
    pickers = {
      find_files = { theme = "dropdown", previewer = false },
      current_buffer_fuzzy_find = { theme = "dropdown", previewer = false },
      buffers = {
        theme = "dropdown",
        previewer = false,
        ignore_current_buffer = true,
        sort_mru = true,
      },
      oldfiles = {
        theme = "dropdown",
        only_cwd = true,
        previewer = false,
        prompt_title = "Recent Files",
        results_title = "",
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    },
  })

  telescope.load_extension "fzf"
end

return M
