-- Icon picker
-- https://github.com/ziontee113/icon-picker.nvim
require "icon-picker"
local fn = require "user.functions"

fn.leaderKeymaps({
	I = {
		CMD "PickIcons",
		"Pick a nerd font icon",
	},
})
