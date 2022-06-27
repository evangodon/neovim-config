--
-- Dim inactive windows
--
local colors = require("catppuccin.api.colors").get_colors()

vim.api.nvim_set_hl(0, "ActiveWindow", { bg = colors.base, fg = colors.none })
vim.api.nvim_set_hl(0, "InactiveWindow", { bg = colors.mantle, fg = colors.none })

-- vim.api.nvim_set_hl(0, "SignColumn", { bg = 'NONE', fg = colors.none })

local function getWinHighlight(highlights)
	local default_win_highlights = {
		Normal = "ActiveWindow",
		NormalNC = "InactiveWindow",
	}
	local win_highlights = vim.tbl_extend("force", default_win_highlights, highlights)

	local winhl_list = {}
	for key, value in pairs(win_highlights) do
		local highlight_link = string.format("%s:%s", key, value)
		table.insert(winhl_list, highlight_link)
	end

	local winhl_str = table.concat(winhl_list, ",")
	return winhl_str
end
vim.opt_local.winhighlight = getWinHighlight({ SignColumn = "ActiveWindow" })

local wm_group = vim.api.nvim_create_augroup("WindowManagement", {})

vim.api.nvim_create_autocmd({ "WinEnter" }, {
	group = wm_group,
	callback = function()
		local ft = vim.bo.filetype
		local in_nvim_tree = ft == "NvimTree"

		local win_highlights = {
			SignColumn = "ActiveWindow",
			CursorLineSign = "ActiveWindow",
		}

		if in_nvim_tree then
			win_highlights["CursorLine"] = "NvimTreeCursorLine"
		end

		vim.opt_local.winhighlight = getWinHighlight(win_highlights)

		local enable = tostring(not in_nvim_tree)
		vim.cmd("Gitsigns toggle_signs " .. enable)
	end,
})

vim.api.nvim_create_autocmd({ "WinLeave" }, {
	group = wm_group,
	callback = function()
		local ft = vim.bo.filetype
		local in_nvim_tree = ft == "NvimTree"

		local win_highlights = {
			SignColumn = "InactiveWindow",
			CursorLineSign = "InactiveWindow",
		}

		if in_nvim_tree then
			win_highlights["CursorLine"] = "NvimTreeCursorLineNC"
		end

		vim.opt_local.winhighlight = getWinHighlight(win_highlights)
	end,
})
