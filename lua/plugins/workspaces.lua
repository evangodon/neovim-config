-- workspaces
-- https://github.com/natecraddock/workspaces.nvim
--
local M = {
  "natecraddock/workspaces.nvim",
  cmd = "Telescope workspaces",
}

function M.config()
  local workspaces = require "workspaces"

  workspaces.setup({
    hooks = {
      open = { "noautocmd NvimTreeOpen" },
    },
  })
end

function M.init()
  local telescope = require "telescope"
  local workspaces = require "workspaces"

  telescope.load_extension "workspaces"

  local function add_new_workspace()
    local cwd = vim.fn.getcwd()
    local workspace_name = vim.fn.input(string.format("Workspace name for [%S]", cwd))
    workspaces.add(cwd, workspace_name)
  end

  local wk = require "which-key"

  wk.add({
    { LeaderKey "w", group = "Workspaces" },
    { LeaderKey "wa", add_new_workspace, desc = "Add workspace with name" },
    { LeaderKey "wo", Cmd "Telescope workspaces", desc = "Open workspace" },
  })
end

return M
