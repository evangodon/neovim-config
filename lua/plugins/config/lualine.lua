-- Lualine
-- https://github.com/nvim-lualine/lualine.nvim

local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

-- local diagnostics = {
-- 	"diagnostics",
-- 	sources = { "nvim_diagnostic" },
-- 	sections = { "error", "warn", "info" },
-- 	diagnostics_color = {
-- 		-- Same values as the general color option can be used here.
-- 		error = "DiagnosticError",
-- 		warn = "DiagnosticWarn",
-- 		info = "DiagnosticInfo",
-- 		hint = "DiagnosticHint",
-- 	},
-- 	symbols = { error = "  ", warn = "  ", info = "  " },
-- 	colored = false,
-- 	update_in_insert = false,
-- 	always_visible = true,
-- }

local diff = {
	"diff",
	colored = false,
	symbols = { added = "ﰂ ", modified = "ﭟ ", removed = "ﯰ " }, -- changes diff symbols
	cond = hide_in_width,
}

local mode = {
	"mode",
	fmt = function(str)
		return "-- " .. str .. " --"
	end,
}

local filetype = {
	"filetype",
	icons_enabled = false,
	icon = nil,
}

local branch = {
	"branch",
	icons_enabled = true,
	icon = " ",
}

local spaces = function()
	return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "〡", right = "〡" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "dashboard", "NvimTree", "Outline" },
		always_divide_middle = true,
	},
	sections = {
		lualine_a = { mode },
		lualine_b = { branch, diff },
		lualine_c = {},
		lualine_x = { spaces, "encoding", filetype },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
})
