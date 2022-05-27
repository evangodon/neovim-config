local configs = require("nvim-treesitter.configs")

configs.setup {
  ensure_installed = {
    "fish",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
  },
  sync_install = false,
  ignore_install = { "" }, -- List of parsers to ignore installing
  autopairs = {
    enable = true
  },
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true, disable = { "yaml" } },
  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    colors = {
      "#F02E6E",
      "#A37ACC",
      "#F2B482",
    }, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  }
}
