local async = require "plenary.async"
local fn = require "user.functions"

-- Create a snapshot before syncing
local function packer_sync()
	async.run(function()
		Notify.async("Syncing packer.", "info", {
			title = "Packer",
		})
	end)
	local snap_shot_time = os.date "!%Y-%m-%dT%TZ"
	vim.cmd("PackerSnapshot " .. snap_shot_time)
	vim.cmd "PackerSync"
end


fn.leaderKeymaps({
	P = {
		name = "Packer",
		u = { ":PackerUpdate<cr>", "Update" },
		s = { packer_sync, "Sync" },
	},
})
