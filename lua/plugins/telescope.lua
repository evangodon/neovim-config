local M = {
	"nvim-telescope/telescope.nvim",
	dependencies = { { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
}

function M.config()
	local telescope = require "telescope"

	local actions = require "telescope.actions"
	local action_layout = require "telescope.actions.layout"

	telescope.setup({
		defaults = {
			prompt_prefix = "  ",
			selection_caret = " ",
			path_display = { "truncate" },
			sorting_strategy = "ascending",
			layout_config = {
				horizontal = {
					prompt_position = "top",
				},
			},
			mappings = {
				i = {
					["<C-n>"] = actions.cycle_history_next,
					["<C-p>"] = actions.cycle_history_prev,

					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,

					["<C-c>"] = actions.close,

					["<Down>"] = actions.move_selection_next,
					["<Up>"] = actions.move_selection_previous,

					["<CR>"] = actions.select_default,
					["<C-x>"] = actions.select_horizontal,
					["<C-v>"] = actions.select_vertical,
					["<C-t>"] = actions.select_tab,

					["<C-u>"] = false,
					-- ["<C-d>"] = actions.preview_scrolling_down,
					["<M-p>"] = action_layout.toggle_preview,

					["<PageUp>"] = actions.results_scrolling_up,
					["<PageDown>"] = actions.results_scrolling_down,

					["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
					["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
					["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
					["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					["<C-l>"] = actions.complete_tag,
					["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
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

					["<Down>"] = actions.move_selection_next,
					["<Up>"] = actions.move_selection_previous,
					["gg"] = actions.move_to_top,
					["G"] = actions.move_to_bottom,

					["<C-u>"] = actions.preview_scrolling_up,
					["<C-d>"] = actions.preview_scrolling_down,

					["<PageUp>"] = actions.results_scrolling_up,
					["<PageDown>"] = actions.results_scrolling_down,

					["?"] = actions.which_key,
				},
			},
		},
		pickers = {
			find_files = {
				theme = "dropdown",
				previewer = false,
			},
			live_grep = {
				theme = "dropdown",
			},
			current_buffer_fuzzy_find = {
				theme = "dropdown",
			},
			-- Default configuration for builtin pickers goes here:
			-- picker_name = {
			--   picker_config_key = value,
			--   ...
			-- }
			-- Now the picker_config_key will be applied every time you call this
			-- builtin picker
		},
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case", default is "smart_case"
			},
		},
	})

	-- Load extensions
	--telescope.load_extension "fzf"

	-- Keymaps
	local map = vim.keymap.set
	local opts = function(desc)
		desc = desc or ""
		return { noremap = true, silent = true, desc = desc }
	end
	local fn = require "user.functions"
	local builtin_pickers = require "telescope.builtin"

	-- Find files
	map("n", "<C-p>", builtin_pickers.find_files, opts "Find Files")

	-- Use grep on files
	map("n", "<C-t>", builtin_pickers.live_grep, opts "Grep files")

	-- Fuzzy search in buffer
	map("n", "<C-f>", builtin_pickers.current_buffer_fuzzy_find, opts "Fuzzy find current buffer")

	fn.registerKeyMap({
		b = {
			CMD "Telescope buffers",
			"Open buffer list",
		},
		r = {
			CMD "Telescope oldfiles",
			"View recent files",
		},
	})
end

return M
