local keyfn = require "user.functions.keyfunc"
local env = require "user.env"
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Save
keymap("n", "<C-s>", CMD "update", opts)
-- better window movement
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- resize with arrows
keymap("n", "<C-Up>", CMD "resize +3", opts)
keymap("n", "<C-Down>", CMD "resize -3", opts)
keymap("n", "<C-Left>", CMD "vertical resize +3", opts)
keymap("n", "<C-Right>", CMD "vertical resize -3", opts)

-- better indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Navigate buffers
keymap("n", "]b", CMD "bnext", opts) -- Next buffer
keymap("n", "<C-n>", CMD "bnext", opts)
keymap("n", "<TAB>", CMD "bnext", opts)
keymap("n", "[b", CMD "bprevious", opts) -- Previous buffer
keymap("n", "<S-TAB>", CMD "bprevious", opts)

vim.api.nvim_create_user_command("CloseBuffer", function()
	local loaded_buffers = Get_loaded_buffers()
	if #loaded_buffers == 1 then
		vim.cmd "bdelete"
	else
		vim.cmd "bnext|BufferClose#"
	end
end, {})
keymap("n", "<C-w>", CMD "CloseBuffer", opts)

-- Move selected line / block of text in visual mode
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- When going up or down one line, use displayed lines instead of physical lines
keymap("n", "k", "gk", opts)
keymap("n", "j", "gj", opts)
keymap("v", "k", "gk", opts)
keymap("v", "$", "g$", opts)

-- Navigate to beginning or ending of line
keymap("n", "H", "0", opts)
keymap("v", "H", "0", opts)
keymap("n", "L", "$", opts)
keymap("v", "L", "$", opts)

keymap("n", "dd", keyfn.smart_dd, { noremap = true, expr = true })

keymap("n", "<Esc>", function()
	require("notify").dismiss() -- clear notifications
	CMD "nohl" -- clear highlights
	CMD "echo " -- clear short-message
end)

keymap("", "<Space>", "<Nop>", opts)

-- Terminal
keymap("t", "<Esc><Esc>", [[<C-\><C-N> :q<CR>]], opts)

-- Disable recording
keymap("n", "Q", "<nop>", opts)
keymap("n", "q", "<nop>", opts)

local fn = require "user.functions.utils"

fn.registerKeyMap({
	s = {
		m = {
			function()
				vim.cmd [[mksession default-session.vim]]
				Notify.info "Created session"
			end,
			"Create session",
		},
		s = {
			function()
				vim.cmd [[source default-session.vim]]
			end,
			"Source session",
		},
	},
	q = {
		CMD "quitall!",
		"Quit",
	},
	l = {
		CMD "noh",
		"Clear highlights",
	},
	c = {
		CMD "close",
		"Close window",
	},
	["-"] = {
		CMD "b#",
		"return to last buffer",
	},
	["]"] = {
		CMD "bnext",
		"Go to next buffer",
	},
	["["] = {
		CMD "bprev",
		"Go to previous buffer",
	},
	-- TODO: create function for this
	--[[ t = { 
		name = "Toggle an option",
		c = {
			function()
				fn.toggleVimOption "cursorcolumn"
			end,
			"Toggle cursorcolumn",
		},
		r = {
			function()
				fn.toggleVimOption "relativenumber"
			end,
			"Toggle relative number",
		},
	}, ]]
	E = {
		function()
			env.printValues()
		end,
		"Show all values in .env file",
	},
})
