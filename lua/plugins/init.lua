require "plugins.packer-init"

local packer_status_ok, packer = pcall(require, "packer")
if not packer_status_ok then
	vim.notify "Error loading packer"
	return
end

local setup_plugin = function(pluginName)
	local path = ("plugins.config." .. pluginName)

	local status_ok, _ = pcall(require, path)

	if not status_ok then
		vim.notify("Error loading plugin at path: " .. path)
		return
	end
end

packer.startup(function(use)
	use "wbthomason/packer.nvim" -- Have packer manage itself
	use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
	use "nvim-lua/plenary.nvim" -- Useful lua functions used in lots of plugins

	-- auto-session
	use({
		"rmagatti/auto-session",
		config = setup_plugin "autosession",
	})
	-- toggleterm
	use({
		"akinsho/toggleterm.nvim",
		config = setup_plugin "toggleterm",
	})

	-- # Code
	-- auto-pairs
	use({
		"windwp/nvim-autopairs",
		config = setup_plugin "autopairs",
	})

	-- UI
	use "kyazdani42/nvim-web-devicons"
	use "fladson/vim-kitty"

	-- nvim-tree
	use({
		"kyazdani42/nvim-tree.lua",
		config = setup_plugin "nvim-tree",
	})
	-- lualine
	use({
		"nvim-lualine/lualine.nvim",
		config = setup_plugin "lualine",
	})
	-- nvim-notify
	use({
		"rcarriga/nvim-notify",
		config = setup_plugin "nvim-notify",
	})
	-- scrollbar
	use({
		"petertriho/nvim-scrollbar",
		config = setup_plugin "scrollbar",
	})
	-- colorizer
	use({
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	})
	-- bufferline
	use({
		"akinsho/bufferline.nvim", -- Bufferline
		config = setup_plugin "bufferline",
		requires = {
			{ "famiu/bufdelete.nvim" }, -- better buffer delete
		},
	})

	--fidget
	use({
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup()
		end,
	})

	use({ "numToStr/Comment.nvim", config = setup_plugin "comment" })

	-- Which-key
	use({ "folke/which-key.nvim", config = setup_plugin "whichkey" })

	-- Neoscroll
	use({ "karb94/neoscroll.nvim", config = setup_plugin "neoscroll" })

	-- Colorschemes
	use "embark-theme/vim"
	use "folke/tokyonight.nvim"
	use "projekt0n/github-nvim-theme"
	use({
		"catppuccin/nvim",
		as = "catppuccin",
	})

	-- cmp plugins
	use({
		"hrsh7th/nvim-cmp",
		config = setup_plugin "cmp",
		requires = {
			"hrsh7th/cmp-buffer", -- buffer completions
			"hrsh7th/cmp-path", -- path completions
			"hrsh7th/cmp-cmdline", -- cmdline completions
			"saadparwaiz1/cmp_luasnip", -- snippet completions
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
		},
	})

	-- Git
	use({
		"lewis6991/gitsigns.nvim",
		config = setup_plugin "gitsigns",
	})

	-- snippets
	use "L3MON4D3/LuaSnip" --snippet engine
	use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

	-- LSP
	use({
		"neovim/nvim-lspconfig",
		requires = {
			"williamboman/nvim-lsp-installer", -- simple to use language server installer
			"jose-elias-alvarez/null-ls.nvim", -- for formatters and linters
		},
	})

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		config = setup_plugin "telescope",
	})

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = setup_plugin "treesitter",
	})
	use "p00f/nvim-ts-rainbow"
	use "JoosepAlviste/nvim-ts-context-commentstring" -- context aware comments

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
