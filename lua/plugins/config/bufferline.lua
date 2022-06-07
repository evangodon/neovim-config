-- Bufferline
-- https://github.com/akinsho/bufferline.nvim

local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
	return
end

bufferline.setup({
	options = {
		numbers = function(opts) -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
			return string.format("%s.", opts.lower(opts.ordinal))
		end,
		close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
		right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
		left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
		middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
		indicator_icon = "▓",
		-- indicator_icon = "█",
		buffer_close_icon = "窱",
		modified_icon = "●",
		close_icon = "",
		left_trunc_marker = "",
		right_trunc_marker = "",
		max_name_length = 30,
		max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
		name_formatter = function(buf)
			return " " .. buf.name
		end,
		tab_size = 21,
		diagnostics = false, -- | "nvim_lsp" | "coc",
		diagnostics_update_in_insert = false,
		offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
		show_buffer_icons = true,
		show_buffer_close_icons = false,
		show_close_icon = false,
		show_tab_indicators = true,
		persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
		-- can also be a table containing 2 custom separators
		-- [focused and unfocused]. eg: { '|', '|' }
		separator_style = { "" }, -- | "thick" | "thin" | { 'any', 'any' },
		enforce_regular_tabs = true,
		always_show_bufferline = true,
		-- sort_by = 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
		--   -- add custom logic
		--   return buffer_a.modified > buffer_b.modified
		-- end
	},
})

local fn = require "user.functions"

-- create key map to navigate buffers
local keymapBufferlineGoToBuffer = function()
	local keymaps = {}

	for i = 8, 1, -1 do
		keymaps[tostring(i)] = {
			string.format(":buffer %d<CR>", i),
			"which_key_ignore",
		}
	end

	return keymaps
end

fn.leaderKeymaps(keymapBufferlineGoToBuffer())

vim.api.nvim_create_autocmd({ "User" }, {
	pattern = "BDeletePost",
	callback = function()
		vim.cmd [[bprevious]]
	end,
	desc = "Go to previous buffer after delete",
})
