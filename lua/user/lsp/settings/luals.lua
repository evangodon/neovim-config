return {
  settings = {
    Lua = {
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "tab",
          tab_width = "2",
          indent_width = "2",
          quote_style = "AutoPreferDouble",
          call_parentheses = "NoSingleString",
        },
      },
      diagnostics = {
        globals = { "vim", "require" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.stdpath "config" .. "/lua"] = true,
        },
      },
    },
  },
}
