return {
  "nvim-lua/popup.nvim", -- An implementation of the Popup API from vim in Neovim
  { "stevearc/dressing.nvim", event = "VeryLazy", config = function()
    require('dressing').setup({
      input = {
        win_options = {
          winblend = 0
        }
      }
    })
  end },
  "jparise/vim-graphql",
  "kyazdani42/nvim-web-devicons"
}
