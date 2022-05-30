local status_ok, packer = pcall(require, "packer")
if not status_ok then
	vim.notify "Error loading packer"
	return
end

return packer.startup(function(use)
	use "wbthomason/packer.nvim" -- Have packer manage itself
	use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
	use "nvim-lua/plenary.nvim" -- Useful lua functions used in lots of plugins
	use "rmagatti/auto-session"
	use "akinsho/toggleterm.nvim" -- ToggleTerm

	-- Code
	use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter

	-- UI
	use "kyazdani42/nvim-web-devicons"
	use "kyazdani42/nvim-tree.lua"
	use "nvim-lualine/lualine.nvim"
	use "rcarriga/nvim-notify"
	use "petertriho/nvim-scrollbar"
	use({
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	})
	use({
		"akinsho/bufferline.nvim", -- Bufferline
		requires = {
			{ "famiu/bufdelete.nvim" }, -- better buffer delete
		},
	})
	use "goolord/alpha-nvim"

	-- Neorg
	use({
		"nvim-neorg/neorg",
		requires = "nvim-lua/plenary.nvim",
	})

	use({ -- Open floating window for command mode
		"VonHeikemen/fine-cmdline.nvim",
		requires = {
			{ "MunifTanjim/nui.nvim" },
		},
	})
	use "numToStr/Comment.nvim" -- Easily comment stuff

	-- Which-key
	use({ "folke/which-key.nvim" })

	-- Neoscroll
	use "karb94/neoscroll.nvim"

	-- Colorschemes
	use "embark-theme/vim"
	use "folke/tokyonight.nvim"
	use "projekt0n/github-nvim-theme"
	use({
		"catppuccin/nvim",
		as = "catppuccin",
	})

	-- cmp plugins
	use "hrsh7th/nvim-cmp" -- The completion plugin
	use "hrsh7th/cmp-buffer" -- buffer completions
	use "hrsh7th/cmp-path" -- path completions
	use "hrsh7th/cmp-cmdline" -- cmdline completions
	use "saadparwaiz1/cmp_luasnip" -- snippet completions
	use "hrsh7th/cmp-nvim-lsp"
	use "hrsh7th/cmp-nvim-lua"

	-- Git
	use "lewis6991/gitsigns.nvim"

	-- snippets
	use "L3MON4D3/LuaSnip" --snippet engine
	use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

	-- LSP
	use "neovim/nvim-lspconfig" -- enable LSP
	use "williamboman/nvim-lsp-installer" -- simple to use language server installer
	use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters
	use({
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup()
		end,
	})

	-- Telescope
	use "nvim-telescope/telescope.nvim"

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use "p00f/nvim-ts-rainbow"
	use "JoosepAlviste/nvim-ts-context-commentstring" -- context aware comments

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
