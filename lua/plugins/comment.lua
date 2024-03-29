-- Comment.nvim
-- https://github.com/numToStr/Comment.nvim
--

local M = {
	"numToStr/Comment.nvim",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	event = "VeryLazy",
}

function M.config()
	local comment = require "Comment"

	comment.setup({
		pre_hook = function(ctx)
			local U = require "Comment.utils"

			local location = nil
			if ctx.ctype == U.ctype.block then
				location = require("ts_context_commentstring.utils").get_cursor_location()
			elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
				location = require("ts_context_commentstring.utils").get_visual_start_location()
			end

			return require("ts_context_commentstring.internal").calculate_commentstring({
				key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
				location = location,
			})
		end,
	})

	local opt = { expr = true, remap = true }

	-- TODO C-/ only works on macos, use C-_ on linux
	-- Toggle using count
	vim.keymap.set(
		"n",
		"<C-_>",
		"v:count == 0 ? '<Plug>(comment_toggle_current_linewise)' : '<Plug>(comment_toggle_linewise_count)'",
		opt
	)
	vim.keymap.set(
		"n",
		"gbc",
		"v:count == 0 ? '<Plug>(comment_toggle_current_blockwise)' : '<Plug>(comment_toggle_blockwise_count)'",
		opt
	)

	-- Toggle in Op-pending mode
	vim.keymap.set("n", "gc", "<Plug>(comment_toggle_linewise)")
	vim.keymap.set("n", "gb", "<Plug>(comment_toggle_blockwise)")
	vim.keymap.set("n", "<C-/>", "<Plug>(comment_toggle_linewise)")

	-- Toggle in VISUAL mode
	vim.keymap.set("x", "gc", "<Plug>(comment_toggle_linewise_visual)")
	vim.keymap.set("x", "<C-_>", "<Plug>(comment_toggle_linewise_visual)")
	vim.keymap.set("x", "gb", "<Plug>(comment_toggle_blockwise_visual)")
	vim.keymap.set("x", "<C-/>", "<Plug>(comment_toggle_blockwise_visual)")
end

return M
