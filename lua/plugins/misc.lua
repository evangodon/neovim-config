return {
  "nvim-lua/popup.nvim", -- An implementation of the Popup API from vim in Neovim
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function()
      require("dressing").setup({
        input = {
          win_options = {
            winblend = 0,
          },
        },
      })
    end,
  },
  { "jparise/vim-graphql", ft = "graphql" },
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
  },
  "kyazdani42/nvim-web-devicons",
}
