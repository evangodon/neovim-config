local M = {
  "EdenEast/nightfox.nvim",
  -- priority = 1000,
}

function M.config()
  local nightfox = require "nightfox"
  local S = require "nightfox.lib.shade"

  nightfox.setup({
    options = {
      -- Compiled file's destination location
      compile_path = vim.fn.stdpath "cache" .. "/nightfox",
      compile_file_suffix = "_compiled", -- Compiled file suffix
      transparent = false, -- Disable setting background
      terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
      dim_inactive = false, -- Non focused panes set to alternative background
      module_default = true, -- Default enable value for modules
      styles = { -- Style to be applied to different syntax groups
        comments = "NONE", -- Value is any valid attr-list value `:help attr-list`
        conditionals = "NONE",
        constants = "NONE",
        functions = "NONE",
        keywords = "NONE",
        numbers = "NONE",
        operators = "NONE",
        strings = "NONE",
        types = "NONE",
        variables = "NONE",
      },
      inverse = { -- Inverse highlight for different types
        match_paren = false,
        visual = false,
        search = false,
      },
      modules = { -- List of various plugins and additional options
        -- ...
      },
    },
    palettes = {
      -- Use old colors for dayfox
      dayfox = {
        black = S.new("#1d344f", "#24476f", "#1c2f44", true),
        red = S.new("#b95d76", "#c76882", "#ac5169", true),
        green = S.new("#618774", "#629f81", "#597668", true),
        yellow = S.new("#ba793e", "#ca884a", "#a36f3e", true),
        blue = S.new("#4d688e", "#4e75aa", "#485e7d", true),
        magenta = S.new("#8e6f98", "#9f75ac", "#806589", true),
        cyan = S.new("#6ca7bd", "#74b2c9", "#5a99b0", true),
        white = S.new("#cdd1d5", "#cfd6dd", "#b6bcc2", true),
        orange = S.new("#e3786c", "#e8857a", "#d76558", true),
        pink = S.new("#d685af", "#de8db7", "#c9709e", true),

        comment = "#7f848e",

        bg0 = "#dbdbdb", -- Dark bg (status line and float)
        bg1 = "#eaeaea", -- Default bg
        bg2 = "#dbcece", -- Lighter bg (colorcolm folds)
        bg3 = "#ced6db", -- Lighter bg (cursor line)
        bg4 = "#bebebe", -- Conceal, border fg

        fg0 = "#182a40", -- Lighter fg
        fg1 = "#1d344f", -- Default fg
        fg2 = "#233f5e", -- Darker fg (status line)
        fg3 = "#2e537d", -- Darker fg (line numbers, fold colums)

        sel0 = "#e7d2be", -- Popup bg, visual selection bg
        sel1 = "#a4c1c2", -- Popup sel bg, search bg
      },
    },
    specs = {},
    groups = {
      all = {
        TelescopeMatching = { fg = "palette.red" },
        DiffAdd = { fg = "palette.green", bg = "NONE" },
        DiffChange = { fg = "palette.yellow", bg = "NONE" },
        DiffDelete = { fg = "palette.red", bg = "NONE" },
        VertSplit = { fg = "palette.bg2", bg = "palette.bg2" },
        TabLineSel = { bg = "palette.red" },
      },
    },
  })
end

return M
