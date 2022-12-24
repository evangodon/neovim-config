-- Icon picker
-- https://github.com/ziontee113/icon-picker.nvim

local M = {
	"ziontee113/icon-picker.nvim",
}

local fn = require "user.functions"


function M.config()
	require "icon-picker"


	fn.registerKeyMap({
		I = {
			CMD "PickIcons",
			"Pick a nerd font icon",
		},
	})
end

return M
