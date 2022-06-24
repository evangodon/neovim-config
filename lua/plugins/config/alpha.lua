-- Alpha
-- https://github.com/goolord/alpha-nvim

local fn = require "user.functions"
local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	Notify.warn "alpha not found"
	return
end

local dashboard = require "alpha.themes.dashboard"

-- TODO: Change icons

dashboard.section.header.val = {
	[[                               __                ]],
	[[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
	[[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
	[[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
	[[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
	[[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
}
dashboard.section.buttons.val = {
	dashboard.button("f", "  Find file", CMD "Telescope find_files "),
	dashboard.button("e", "  New file", CMD "ene <BAR> startinsert "),
	dashboard.button("p", "  Find project", CMD "Telescope projects "),
	dashboard.button("r", "  Recently used files", CMD "Telescope oldfiles "),
	dashboard.button("t", "  Find text", CMD "Telescope live_grep "),
	dashboard.button("s", "痢 Sync plugins", CMD "CreateSnapshotAndSyncPlugins"),
	dashboard.button("c", "  Configuration", CMD "e ~/.config/nvim/init.lua "),
	dashboard.button("q", "  Quit Neovim", CMD "qa"),
}

local function footer()
	return ""
end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true

fn.leaderKeymaps({
	A = {
		":Alpha<CR>",
		"Open Alpha dashboard",
	},
})

alpha.setup(dashboard.opts)
