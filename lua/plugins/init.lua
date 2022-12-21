require "plugins.packer-init"
require "plugins.packer-keymaps"
local packer = require "packer"

packer.startup(function(use)
	use "wbthomason/packer.nvim" -- Have packer manage itself
	use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
	use "nvim-lua/plenary.nvim" -- Useful lua functions used in lots of plugins
	use({ "ojroques/vim-oscyank", branch = "main" })

	-- Colorschemes
	use({ "catppuccin/nvim", as = "catppuccin" })

	use "EdenEast/nightfox.nvim" -- Packer

	use({
		"goolord/alpha-nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
	})

	-- nvim-notify
	use({ "rcarriga/nvim-notify" })

	-- toggleterm
	use({ "akinsho/toggleterm.nvim" })

	-- # Code
	-- auto-pairs
	use({ "windwp/nvim-autopairs" })

	--go.nvim
	use({ "ray-x/go.nvim" })
	use "cespare/vim-go-templates"

	-- Graphql
	use({ "jparise/vim-graphql" })

	-- UI
	use "kyazdani42/nvim-web-devicons"
	use "fladson/vim-kitty"
	use({ "lukas-reineke/indent-blankline.nvim" })
	use({ "folke/zen-mode.nvim" })
	use "stevearc/dressing.nvim"
	use({ "ziontee113/icon-picker.nvim" })

	-- nvim-tree
	use({ "kyazdani42/nvim-tree.lua" })

	-- lualine
	use({ "nvim-lualine/lualine.nvim" })

	-- scrollbar
	use({ "petertriho/nvim-scrollbar" })

	-- todo-comments
	use({
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
	})

	-- colorizer
	use({ "norcalli/nvim-colorizer.lua" })

	-- bufferline
	use({
		"romgrk/barbar.nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
	})

	-- Project management
	use({ "natecraddock/workspaces.nvim" })

	--fidget
	use({ "j-hui/fidget.nvim" })

	use({ "numToStr/Comment.nvim" })

	-- Which-key
	use({ "folke/which-key.nvim" })

	-- Neoscroll
	use({ "karb94/neoscroll.nvim" })

	-- cmp plugins
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-buffer", -- buffer completions
			"hrsh7th/cmp-path", -- path completions
			"hrsh7th/cmp-cmdline", -- cmdline completions
			"saadparwaiz1/cmp_luasnip", -- snippet completions
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
		},
	})

	-- Gitsigns
	use({ "lewis6991/gitsigns.nvim" })

	-- snippets
	use "L3MON4D3/LuaSnip" --snippet engine
	use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

	-- LSP
	use({
		"VonHeikemen/lsp-zero.nvim",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
		},
	})
	use({
		"neovim/nvim-lspconfig",
		"jose-elias-alvarez/null-ls.nvim", -- for formatters and linters
	})

	-- Telescope
	use({ "nvim-telescope/telescope.nvim" })
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use "p00f/nvim-ts-rainbow"
	use "JoosepAlviste/nvim-ts-context-commentstring" -- context aware comments

	-- Github Copilot
	-- use({
	-- 	"github/copilot.vim",
	-- 	config = function()
	-- 		vim.api.nvim_set_var("copilot_filetypes", {
	-- 			TelescopePrompt = false,
	-- 		})
	-- 	end,
	-- })

	-- ZK
	use({ "mickael-menu/zk-nvim" })

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
