local M = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"mrjones2014/nvim-ts-rainbow",
	},
	event = "BufReadPost",
}

function M.config()
	local configs = require "nvim-treesitter.configs"

	-- vim.g.markdown_fenced_languages = { "html", "python", "lua", "vim", "typescript", "javascript" }

	configs.setup({
		ensure_installed = {
			"markdown",
			"markdown_inline",
			"fish",
			"lua",
			"html",
			"css",
			"javascript",
			"typescript",
			"tsx",
			"go",
		},
		sync_install = false,
		ignore_install = { "" }, -- List of parsers to ignore installing
		autopairs = {
			enable = true,
		},
		highlight = {
			enable = true, -- false will disable the whole extension
			disable = { "" }, -- list of language that will be disabled
			additional_vim_regex_highlighting = true,
		},
		indent = { enable = true, disable = { "yaml" } },

		rainbow = {
			enable = true,
			-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
			extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
			max_file_lines = nil, -- Do not enable for files with more than n lines, int
			-- colors = {
			-- "#F2B482",
			-- "#F02E6E",
			-- "#A37ACC",
			-- },
		},
		context_commentstring = {
			enable = true,
			enable_autocmd = false,
		},
	})
end

return M
