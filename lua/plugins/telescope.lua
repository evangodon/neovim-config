local M = {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	event = "VeryLazy",
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

					["gg"] = actions.move_to_top,
					["G"] = actions.move_to_bottom,

					["<C-u>"] = actions.preview_scrolling_up,
					["<C-d>"] = actions.preview_scrolling_down,

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
			buffers = {
				theme = "dropdown",
				previewer = false,
				initial_mode = "normal",
				ignore_current_buffer = true,
			},
			oldfiles = {
				only_cwd = true,
			},
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
end

function M.init()
	local telescope = require "telescope"
	-- Load extensions
	-- telescope.load_extension "fzf"
	telescope.load_extension "knowledge_base"
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
		b = { builtin_pickers.buffers, "Open buffer list" },
		G = {
			s = {
				function()
					builtin_pickers.git_status({ ignore_current_buffer = true, initial_mode = "normal" })
				end,
				"Git Status",
			},
		},
		r = { builtin_pickers.oldfiles, "View recent files" },
		k = {
			CMD "Telescope knowledge_base list",
			"View knowledge base",
		},
		m = {
			builtin_pickers.marks,
			"View Marks",
		},
		d = {
			CMD "Telescope diagnostics",
			"View Diagnostics",
		},
	})
end

return M
