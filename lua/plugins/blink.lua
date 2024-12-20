local M = {
  "saghen/blink.cmp",
  lazy = false,
  dependencies = "rafamadriz/friendly-snippets",

  version = "v0.*",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    enabled = function()
      return not vim.tbl_contains({ "DressingInput" }, vim.bo.filetype) and vim.bo.buftype ~= "prompt"
    end,
    keymap = { preset = "enter" },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "normal",
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    -- signature = { enabled = true }
    completion = {
      menu = {
        max_height = 8,
        draw = {
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
        },
      },
    },
  },
  opts_extend = { "sources.default" },
}

return M
