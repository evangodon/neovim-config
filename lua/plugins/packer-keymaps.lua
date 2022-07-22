local async = require "plenary.async"
local fn = require "user.functions.utils"

-- Create a snapshot before syncing
local function packerSnapshotAndSync()
	async.run(function()
		Notify.async("Syncing packer.", "info", {
			title = "Packer",
		})
	end)
	local snap_shot_time = os.date "!%Y-%m-%dT%TZ"
	vim.cmd("PackerSnapshot " .. snap_shot_time)
	vim.cmd "PackerSync"
end

vim.api.nvim_create_user_command("CreateSnapshotAndSyncPlugins", function()
	packerSnapshotAndSync()
end, {})

fn.leaderKeymaps({
	P = {
		name = "Packer",
		u = { CMD "PackerUpdate", "Update" },
		s = { packerSnapshotAndSync, "Sync" },
	},
})
