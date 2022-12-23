-- Null-LS
-- https://github.com/jose-elias-alvarez/null-ls.nvim

local M = {
	"jose-elias-alvarez/null-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
}

function M.config()
	local null_ls = require "null-ls"

	-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
	local formatting = null_ls.builtins.formatting
	-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics

	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

	null_ls.setup({
		debug = false,
		sources = {
			-- Lua
			formatting.stylua,
			-- JS
			formatting.prettier,
			-- Go
			formatting.gofmt,
			formatting.golines,
			formatting.goimports,
		},
		on_attach = function(client, bufnr)
			-- Format on save
			if client.supports_method "textDocument/formatting" then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({ bufnr = bufnr })
					end,
				})
			end
		end,
	})
end

return M
