local M = {
	"VonHeikemen/lsp-zero.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
}

function M.config()
	local lsp = require "lsp-zero"

	lsp.preset "recommended"

	lsp.ensure_installed({
		"tsserver",
		"eslint",
		"sumneko_lua",
		"gopls",
		"jsonls",
	})

	lsp.set_preferences({
		suggest_lsp_servers = true,
		sign_icons = {
			error = "•",
			warn = "•",
			hint = "•",
			info = "•",
		},
	})

	vim.diagnostic.config({
		virtual_text = true,
	})

	-- LSP server configurations
	lsp.configure("sumneko_lua", require "user.lsp.settings.sumneko_lua")
	lsp.configure("jsonls", require "user.lsp.settings.jsonls")

	-- Keymaps
	lsp.on_attach(function(_, bufnr)
		local function setBufOpts(desc)
			return { noremap = true, silent = true, buffer = bufnr, desc = desc }
		end

		local keymap = vim.keymap.set

		keymap("n", "gD", vim.lsp.buf.declaration, setBufOpts "Jump to declaration")
		keymap("n", "gd", vim.lsp.buf.definition, setBufOpts "Jump to definition")
		keymap("n", "gh", vim.lsp.buf.hover, setBufOpts "Hover")
		keymap("n", "gi", vim.lsp.buf.implementation, setBufOpts "Implementation")
		keymap("n", "<C-k>", vim.lsp.buf.signature_help, setBufOpts "Signature help")
		keymap("n", "gr", vim.lsp.buf.references, setBufOpts "Find references")
		keymap("n", "<F2>", vim.lsp.buf.rename, setBufOpts "Rename")
		keymap("n", "[d", function()
			vim.diagnostic.goto_prev({ border = "single" })
		end, setBufOpts "Jump to previous diagnostic")
		keymap("n", "gl", function()
			vim.diagnostic.open_float({ border = "single" })
		end, setBufOpts "Open diagnostics")
		keymap("n", "]d", function()
			vim.diagnostic.goto_next({ border = "single" })
		end, setBufOpts "Jump to next diagnostic")
		keymap("n", "<leader>f", vim.lsp.buf.formatting, setBufOpts "Format document")
	end)

	lsp.setup()
end

return M
