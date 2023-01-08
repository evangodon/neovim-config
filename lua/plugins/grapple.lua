local backslash = [[\]]

local M = {
	"cbochs/grapple.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "folke/which-key.nvim" },
	keys = backslash,
}

function M.config()
	require("grapple").setup({
		log_level = "warn",
		scope = "git",
		popup_options = {
			relative = "editor",
			width = 60,
			height = 12,
			style = "minimal",
			focusable = false,
			border = "single",
		},

		integrations = {
			resession = false,
		},
	})
end

local function register_key_map(key, action, desc)
	local whichkey = require "which-key"
	local rhs = action == "<Nop>" and "which_key_ignore" or { action, desc }
	key = tostring(key)

	whichkey.register({ [key] = rhs }, {
		prefix = backslash,
		mode = "n",
	})
end

-- Add GrappleSelect keymap and center viewport
local function add_select_keymap(key, filename)
	register_key_map(key, CMD("GrappleSelect key=" .. key) .. " |zz", "Go to [" .. filename .. "]")
end

-- Remove GrappleSelect keymap
local function remove_select_keymap(key)
	register_key_map(key, "<Nop>", "")
end

-- Unset all select keymaps
local function unset_all_select_keymaps()
	local s = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

	for i = 1, #s do
		local key = s:sub(i, i)
		register_key_map(key, "<Nop>", "")
	end
end

-- Set keymaps for active tags
local function set_named_select_keymap()
	local settings = require "grapple.settings"
	local scope = require("grapple.state").ensure_loaded(settings.scope)
	local popup_items = require("grapple.tags").full_tags(scope)
	for _, item in pairs(popup_items) do
		local key = tostring(item.key)
		local filename = string.match(item.file_path, "[^/]+$")
		if #key == 1 then
			add_select_keymap(key, filename)
		end
	end
end

-- Update all Grapple select keymaps
local groupname = vim.api.nvim_create_augroup("grapple-update", {})
vim.api.nvim_create_autocmd({ "BufLeave" }, {
	group = groupname,
	callback = function()
		if vim.bo.filetype == "grapple" then
			unset_all_select_keymaps()
			set_named_select_keymap()
		end
	end,
})

-- TODO: Show tag next to buffer name
-- TODO: Create main jump tag keymap
function M.init()
	local grapple = require "grapple"
	local whichkey = require "which-key"

	set_named_select_keymap()

	whichkey.register({
		["="] = {
			function()
				grapple.tag()
				local key = grapple.key()
				add_select_keymap(key)
			end,
			"Tag",
		},
		["-"] = {
			function()
				local key = grapple.key()
				remove_select_keymap(key)
				grapple.untag()
			end,
			"Untag",
		},
		[backslash] = {
			function()
				grapple.popup_tags()
			end,
			"View tags",
		},
		["]"] = {
			grapple.cycle_forward,
			"Cycle forward",
		},
		["["] = {
			grapple.cycle_backward,
			"Cycle back",
		},
	}, {
		prefix = backslash,
		mode = "n",
	})
end

return M
