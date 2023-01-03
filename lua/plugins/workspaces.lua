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

  local fn = require "user.functions"
  fn.registerKeyMap({
    p = {
      CMD "Telescope workspaces",
      "View projects",
    },
    W = {
      name = "Workspaces",
      A = {
        function()
          local cwd = vim.loop.cwd()
          local workspace_name = vim.fn.input(string.format("[%s] Workspace name: ", cwd))
          workspaces.add(workspace_name, cwd)
        end,
        "Create new workspace",
      },
      D = {
        CMD "WorkspacesRemove",
        "Create new workspace",
      },
    },
  })
end

return M
