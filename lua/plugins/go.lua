local M = {
	"ray-x/go.nvim",
}


function M.config()
	local go = require "go"

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
end

return M
