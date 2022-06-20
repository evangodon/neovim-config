local project_nvim = require "project_nvim"
local fn = require "user.functions"

project_nvim.setup({
	respect_buf_cwd = true,
	update_cwd = true,
	update_focused_file = {
		enable = true,
		update_cwd = true,
	},
})

require("telescope").load_extension "projects"

fn.leaderKeymaps({
	p = {
		":Telescope projects <CR>",
		"View projects",
	},
})
