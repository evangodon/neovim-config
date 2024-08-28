return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = "markdown",
  opts = {},
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  config = function()
    require("render-markdown").setup({
      bullet = {
        icons = { "•", "○", "◆", "◇" },
        -- Padding to add to the left of bullet point
        left_pad = 0,
        -- Padding to add to the right of bullet point
        right_pad = 1,
        -- Highlight for the bullet icon
        highlight = "RenderMarkdownBullet",
      },
    })
  end,
}
