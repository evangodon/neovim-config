local bufferline = require "bufferline"

bufferline.setup({
	icon_separator_active = "▓",
	icon_separator_inactive = "▓",
})

local nvim_tree_events = require "nvim-tree.events"
local bufferline_state = require "bufferline.state"
local fn = require "user.functions"

nvim_tree_events.on_tree_open(function()
	bufferline_state.set_offset(NvimTreeWidth, "File Tree")
	vim.cmd [[wincmd p]]
end)

nvim_tree_events.on_tree_close(function()
	bufferline_state.set_offset(0)
end)

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "[B", CMD "BufferMovePrev", opts)
keymap("n", "]B", CMD "BufferMoveNext", opts)

-- create key map to navigate buffers
local keymapBufferlineGoToBuffer = function()
	local keymaps = {}

	for i = 8, 1, -1 do
		keymaps[tostring(i)] = {
			string.format(CMD "BufferGoto %d", i),
			"which_key_ignore",
		}
	end

	return keymaps
end

fn.leaderKeymaps(keymapBufferlineGoToBuffer())
