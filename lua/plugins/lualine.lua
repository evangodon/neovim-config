-- Lualine
-- https://github.com/nvim-lualine/lualine.nvim

local M = {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
}

function M.config()
  local lualine = require "lualine"
  local  icons = require "user.icons"

  local function hide_in_width()
    return vim.fn.winwidth(0) > 80
  end

  local diff = {
    "diff",
    symbols = { added = "洛", modified = " ", removed = " " },
    cond = hide_in_width,
    colored = true,
    diff_color = {
      added = "DiffAdd",
      modified = "DiffChange",
      removed = "DiffDelete",
    },
    fmt = function(str)
      return str
    end,
  }

  local mode = {
    "mode",
    fmt = function(str)
      return "-- " .. str .. " --"
    end,
  }

  local filetype = {
    "filetype",
    icons_enabled = false,
    icon = nil,
  }

  local branch = {
    "branch",
    icons_enabled = true,
    icon = "",
  }

  local project_root = {
    function()
      return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    end,
    icon = "",
    cond = hide_in_width,
  }
  local grapple_key = {
    function()
      local key = require("grapple").key()
      return " " .. key .. ""
    end,
    cond = require("grapple").exists,
  }

  local function spaces()
    return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
  end

  local filename = {
    "filename",
    path = 1,
    fmt = function(str)
      if string.find(str, "No Name") then
        return ""
      end
      return string.gsub(str, "/", " › ")
    end,
  }

  local dot = icons.diagnostics.default

  local diagnostics = {
    "diagnostics",
    symbols = { error = dot, warn = dot, info = dot, hint = dot },
  }

  lualine.setup({
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { statusline = { "dashboard", "NvimTree", "Outline" }, winbar = { "NvimTree" } },
      always_divide_middle = true,
    },
    extensions = { "symbols-outline", "toggleterm" },
    sections = {
      lualine_a = { mode },
      lualine_b = { branch },
      lualine_c = { diff, project_root },
      lualine_x = { grapple_key, spaces, "encoding" },
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
      lualine_b = {},
      lualine_c = { filename },
      lualine_x = { diagnostics },
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
