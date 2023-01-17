-- Alpha
-- https://github.com/goolord/alpha-nvim

local M = {
  "goolord/alpha-nvim",
  dependencies = { "kyazdani42/nvim-web-devicons" },
  enabled = true,
  cmd = "Alpha"
}

function M.config()
  local alpha = require "alpha"

  local dashboard = require "alpha.themes.dashboard"
  local header = "▒▒  NEOVIM  ▒▒"

  dashboard.section.header.val = { "", "", header, "" }

  dashboard.section.buttons.val = {
    dashboard.button("p", "  Find project", CMD "Telescope workspaces  initial_mode=normal"),
    dashboard.button("r", "  Recently used files", CMD "Telescope oldfiles "),
    dashboard.button("c", "  Neovim Config", CMD "edit ~/.config/nvim/"),
    dashboard.button("t", "  Open Todo list", CMD ":edit ~/.config/nvim/todo.md"),
    dashboard.button("q", "  Quit", CMD "qa"),
  }

  local function footer()
    return vim.fn.getcwd()
  end

  dashboard.section.footer.val = footer()

  dashboard.section.footer.opts.hl = "Include"
  dashboard.section.header.opts.hl = "Include"
  dashboard.section.buttons.opts.hl = "Keyword"

  dashboard.opts.opts.noautocmd = true

  alpha.setup(dashboard.opts)

end

function M.init()
  local fn = require "user.functions.utils"
  fn.register_key_map({
    A = {
      CMD "Alpha",
      "Open Alpha dashboard",
    },
  })
end

return M
