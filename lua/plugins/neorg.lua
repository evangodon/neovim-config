-- Neorg
-- https://github.com/nvim-neorg/neorg

local status_ok, neorg = pcall(require, "neorg")
if not status_ok then
	return
end

neorg.setup({
	load = {
		["core.defaults"] = {},
		["core.norg.concealer"] = {
			config = {},
		},
	},
})
