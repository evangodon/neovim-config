-- Toggleterm
-- https://github.com/akinsho/toggleterm.nvim
--
local M = {
	"akinsho/toggleterm.nvim",
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

	-- Set terminal keymaps
	vim.api.nvim_create_autocmd({ "TermOpen" }, {
		callback = function()
			local opts = { noremap = true }
			vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
		end,
	})

	-- Custom Terminals
	local Terminal = require("toggleterm.terminal").Terminal

	local todo = Terminal:new({ cmd = "todo view", close_on_exit = true })

	function _TODO_TOGGLE()
		todo:toggle()
	end

	local dash = Terminal:new({ cmd = "dash", hidden = true })

	function _DASH_TOGGLE()
		dash:toggle()
	end

	local fn = require "user.functions"
	fn.registerKeyMap({
		D = {
			function()
				dash:toggle()
			end,
			"Open [D]ashboard",
		},
	})
end

return M
