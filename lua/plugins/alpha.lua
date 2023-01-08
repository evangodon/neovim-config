-- Alpha
-- https://github.com/goolord/alpha-nvim

local M = {
	"goolord/alpha-nvim",
	dependencies = { "kyazdani42/nvim-web-devicons" },
	lazy = false,
}

function M.config()
	local alpha = require "alpha"
	local fn = require "user.functions.utils"

	local dashboard = require "alpha.themes.dashboard"

	dashboard.section.header.val = { "", "", "▒▒  NEOVIM  ▒▒" }
	dashboard.section.buttons.val = {
		dashboard.button("p", "  Find project", CMD "Telescope workspaces"),
		dashboard.button("r", "  Recently used files", CMD "Telescope oldfiles "),
		dashboard.button("s", "痢 Sync plugins", CMD "CreateSnapshotAndSyncPlugins"),
		dashboard.button("c", "  Configuration", CMD "e ~/.config/nvim/init.lua "),
		dashboard.button("t", "  Open Todo list", CMD ":edit ~/.config/nvim/todo.md"),
		dashboard.button("q", "  Quit", CMD "qa"),
	}

	local function footer()
		return ""
	end

	dashboard.section.footer.val = footer()

	dashboard.section.footer.opts.hl = "Type"
	dashboard.section.header.opts.hl = "Include"
	dashboard.section.buttons.opts.hl = "Keyword"

	dashboard.opts.opts.noautocmd = true

	fn.register_key_map({
		A = {
			":Alpha<CR>",
			"Open Alpha dashboard",
		},
	})

	alpha.setup(dashboard.opts)
end

return M
