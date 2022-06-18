-- ZK
-- https://github.com/mickael-menu/zk-nvim

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
			-- on_attach = ...
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
				zk.new({ title = vim.fn.input "Title: " })
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
