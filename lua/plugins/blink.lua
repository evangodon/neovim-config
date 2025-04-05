local M = {
  "saghen/blink.cmp",
  enabled = true,
  lazy = false,
  dependencies = "rafamadriz/friendly-snippets",

  version = "v0.*",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    enabled = function()
      return not vim.tbl_contains({ "DressingInput" }, vim.bo.filetype) and vim.bo.buftype ~= "prompt"
    end,
    keymap = {
      preset = "enter",
      [Ctrl "k"] = { "select_prev", "fallback" },
      [Ctrl "j"] = { "select_next", "fallback" },
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
    },

    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "normal",
    },

    sources = {
      default = { "lazydev", "lsp", "path", "snippets", "buffer" },
      providers = {
        snippets = {
          max_items = 5,
          min_keyword_length = 2,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
      },
    },

    -- signature = { enabled = true }
    completion = {
      menu = {
        max_height = 8,
        draw = {
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" }, { "source_name", gap = 1 } },
        },
        border = "none",
      },
      trigger = {
        show_on_trigger_character = true,
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 300,
        window = { border = "single" },
      },
    },
  },
  opts_extend = { "sources.default" },
}

return M
