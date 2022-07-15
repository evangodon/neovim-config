-- ZK
-- https://github.com/mickael-menu/zk
-- https://github.com/mickael-menu/zk-nvim
--
-- Install `zk` with `brew install zk` or `yay -S zk`

local zk = require "zk"
local zk_util = require "zk.util"
local fn = require "user.functions"

zk.setup({
	picker = "telescope",
	lsp = {
		-- `config` is passed to `vim.lsp.start_client(config)`
		config = {
			cmd = { "zk", "lsp" },
			name = "zk",
			on_attach = function(_, bufnr)
				local function setBufOpts(desc)
					return { noremap = true, silent = true, buffer = bufnr, desc = desc }
				end
				local keymap = vim.keymap.set
				-- https://github.com/mickael-menu/zk-nvim#example-mappings

				keymap("n", "gh", vim.lsp.buf.hover, setBufOpts "Preview note")
				keymap("n", "<CR>", vim.lsp.buf.definition, setBufOpts "Go to note")
				keymap("n", "gd", vim.lsp.buf.definition, setBufOpts "Go to note")
				keymap("n", "gl", function()
					vim.diagnostic.open_float()
				end, setBufOpts "Open diagnostics")
			end,
			-- etc, see `:h vim.lsp.start_client()`
		},
		-- automatically attach buffers in a zk notebook that match the given filetypes
		auto_attach = {
			enabled = true,
			filetypes = { "markdown" },
		},
	},
})

-- Verify that the file is in a zk notebook
local function fileIsInNotebook()
	local in_notebook = zk_util.notebook_root(vim.fn.expand "%:p") ~= nil
	if not in_notebook then
		Notify.warn "Not in a zk notebook"
		return false
	end
	return true
end

fn.leaderKeymaps({
	z = {
		name = "zk",
		-- New Note
		n = {
			function()
				local in_notebook = fileIsInNotebook()
				if not in_notebook then
					return
				end
				-- Get list of directories, use ZkCd to go to root
				-- Show prompt to get selection or use "."
				-- Add dir option to zk.new
				local dir = vim.fn.input "Enter which folder: "
				local title = vim.fn.input(string.format("[%s] Enter title: ", dir))

				zk.new({ title = title, dir = dir })
			end,
			"New note",
		},
		-- Open Note
		o = {
			function()
				local in_notebook = fileIsInNotebook()
				if not in_notebook then
					return
				end
				zk.edit({}, { title = "Zk Notes" })
			end,
			"Open note",
		},
		-- See Links
		l = {
			function()
				local in_notebook = fileIsInNotebook()
				if not in_notebook then
					return
				end
				local buffer = vim.api.nvim_buf_get_name(0)
				zk.edit({ linkedBy = { buffer } }, { title = "Zk Links" })
			end,
			"See links",
		},
	},
})
