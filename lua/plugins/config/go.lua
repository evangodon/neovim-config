local status_ok, go = pcall(require, "go")
if not status_ok then
	vim.notify "error calling go module"
	return
end

go.setup()

local fn = require "user.functions"

fn.leaderKeymaps({
	g = {
		name = "Go",
		f = { ":GoFillStruct<cr>", "Fill struct" },
		i = { ":GoImport<cr>", "Go imports" },
		g = { ":GoFmt<cr>", "Format" },
	},
})
