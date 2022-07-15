-- Lualine
-- https://github.com/nvim-lualine/lualine.nvim

local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local diff = {
	"diff",
	symbols = { added = "洛", modified = " ", removed = " " },
	cond = hide_in_width,
	colored = true,
	diff_color = {
		added = "DiffAdd",
		modified = "DiffChange",
		removed = "DiffDelete",
	},
	fmt = function(str)
		return str
	end,
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
	icon = "",
}

-- TODO can be better
local function rootFolder()
	local cwd = vim.loop.cwd()
	local dir = string.match(cwd, "/(%w+)$")
	return "  " .. dir
end

local filename = {
	"filename",
	fmt = function(str)
		if string.find(str, "No Name") then
			return ""
		end

		return str
	end,
}

local function spaces()
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
		lualine_b = { branch },
		lualine_c = { diff, rootFolder, filename },
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
