-- workspaces
-- https://github.com/natecraddock/workspaces.nvim
--
local M = {
	"natecraddock/workspaces.nvim",
}

function M.config()
	local workspaces = require "workspaces"
	local telescope = require "telescope"
	local fn = require "user.functions"

	workspaces.setup({
		hooks = {
			open = { "noautocmd NvimTreeOpen" },
		},
	})

	telescope.load_extension "workspaces"

	fn.registerKeyMap({
		p = {
			CMD "Telescope workspaces",
			"View projects",
		},
		W = {
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
