require "plugins.packer-init"

local packer_status_ok, packer = pcall(require, "packer")
if not packer_status_ok then
	Notify.info "Error loading packer"
	return
end

local function safe_require(pluginName)
	local path = ("plugins.config." .. pluginName)

	local status_ok, _ = pcall(require, path)

	if not status_ok then
		Notify.error("Error loading plugin at path: " .. path)
		return
	end
end

-- call setup() on plugin
local function safe_setup(pluginName)
	local status_ok, plugin = pcall(require, pluginName)
	if not status_ok then
		Notify.error("Error loading plugin: " .. pluginName)
		return
	end

	plugin.setup()
end

packer.startup(function(use)
	use "wbthomason/packer.nvim" -- Have packer manage itself
	use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
	use "nvim-lua/plenary.nvim" -- Useful lua functions used in lots of plugins

	use({
		"goolord/alpha-nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
		config = safe_require "alpha",
	})

	-- nvim-notify
	use({
		"rcarriga/nvim-notify",
		config = safe_require "nvim-notify",
	})

	-- auto-session
	use({
		"rmagatti/auto-session",
		config = safe_require "autosession",
	})
	-- toggleterm
	use({
		"akinsho/toggleterm.nvim",
		config = safe_require "toggleterm",
	})

	-- # Code
	-- auto-pairs
	use({
		"windwp/nvim-autopairs",
		config = safe_require "autopairs",
	})

	--go.nvim
	use({
		"ray-x/go.nvim",
		config = safe_require "go",
		as = "go",
	})
	-- Graphql
	use({ "jparise/vim-graphql" })

	-- UI
	use "kyazdani42/nvim-web-devicons"
	use "fladson/vim-kitty"
	use({
		"VonHeikemen/fine-cmdline.nvim",
		config = safe_require "fine-cmdline",
		requires = {
			{ "MunifTanjim/nui.nvim" },
		},
	})

	-- nvim-tree
	use({
		"kyazdani42/nvim-tree.lua",
		config = safe_require "nvim-tree",
	})
	-- lualine
	use({
		"nvim-lualine/lualine.nvim",
		config = safe_require "lualine",
	})
	-- scrollbar
	use({
		"petertriho/nvim-scrollbar",
		config = safe_require "scrollbar",
	})
	-- colorizer
	use({
		"norcalli/nvim-colorizer.lua",
		config = safe_setup "colorizer",
	})
	-- bufferline
	use({
		"akinsho/bufferline.nvim", -- Bufferline
		config = safe_require "bufferline",
		requires = {
			{ "famiu/bufdelete.nvim" }, -- better buffer delete
		},
	})

	--fidget
	use({
		"j-hui/fidget.nvim",
		config = safe_setup "fidget",
	})

	use({ "numToStr/Comment.nvim", config = safe_require "comment" })

	-- Which-key
	use({ "folke/which-key.nvim", config = safe_require "whichkey" })

	-- Neoscroll
	use({ "karb94/neoscroll.nvim", config = safe_require "neoscroll" })

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
		config = safe_require "cmp",
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
		config = safe_require "gitsigns",
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
		config = safe_require "telescope",
	})

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = safe_require "treesitter",
	})
	use "p00f/nvim-ts-rainbow"
	use "JoosepAlviste/nvim-ts-context-commentstring" -- context aware comments

	-- Github Copilot
	use({ "github/copilot.vim" })

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
