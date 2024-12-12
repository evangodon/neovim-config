-- Lualine
-- https://github.com/nvim-lualine/lualine.nvim

local M = {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    "cbochs/grapple.nvim",
  },
}

function M.config()
  local lualine = require "lualine"
  local icons = require "user.icons"
  local utils = require "user.functions.utils"
  local grapple = require "grapple"

  local function hide_in_width()
    return vim.fn.winwidth(0) > 80
  end

  local diff = {
    "diff",
    symbols = { added = "", modified = "", removed = "" },
    cond = hide_in_width,
    colored = true,
    diff_color = {
      added = "DiffAdd",
      modified = "DiffChange",
      removed = "DiffDelete",
    },
    fmt = function(str)
      local withSuperscripts = utils.all_nums_to_superscript(str)
      return withSuperscripts
    end,
  }

  local mode = {
    "mode",
    icons_enabled = true,
  }

  local filetype = {
    "filetype",
    icons_enabled = true,
    icon = nil,
    colored = false,
  }

  local branch = {
    "branch",
    icons_enabled = true,
    icon = "",
    fmt = function(str)
      return utils.truncate_string(str, 20)
    end,
  }

  local grapple_key = {
    function()
      local tag = grapple.name_or_index()
      return " " .. tag .. ""
    end,
    cond = grapple.exists,
  }

  local function spaces()
    return "󱁐 " .. vim.bo.shiftwidth
  end

  local function lsp_status()
    local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
    if next(buf_clients) == nil then
      return "" -- No LSP attached to current buffer
    end

    local count = 0
    for _ in pairs(buf_clients) do
      count = count + 1
    end

    return " " .. count
  end

  local filename = {
    "filename",
    path = 1,
    symbols = {
      modified = "[+]",
      readonly = "[-]",
      unnamed = "[No Name]",
      newfile = "[New]",
    },
    fmt = function(str)
      return string.gsub(str, "/", " › ")
    end,
  }

  local dot = icons.diagnostics.default

  local diagnostics = {
    "diagnostics",
    symbols = { error = dot, warn = dot, info = dot, hint = dot },
    fmt = function(str)
      return str
    end,
  }

  lualine.setup({
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { statusline = { "dashboard", "NvimTree", "Outline" }, winbar = { "NvimTree", "alpha" } },
      always_divide_middle = true,
    },
    extensions = { "symbols-outline", "toggleterm" },
    sections = {
      lualine_a = { mode },
      lualine_b = { branch },
      lualine_c = { diff },
      lualine_x = { grapple_key, spaces, lsp_status },
      lualine_y = { filetype },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    winbar = {
      lualine_a = {},
      lualine_b = { filename },
      lualine_c = { diagnostics },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    inactive_winbar = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { filename },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  })
end

return M
