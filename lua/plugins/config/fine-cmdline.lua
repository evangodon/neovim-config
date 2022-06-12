			-- stylua: ignore
local status_ok, cmdline = pcall(require, "fine-cmdline")
if not status_ok then
	return
end

-- stylua: ignore start
local borderStyle =  {
				top_left    = " ╭", top    = "─",    top_right = "╮ ",
				left        = " │",                      right = "│ ",
				bottom_left = " ╰", bottom = "─", bottom_right = "╯ ",
			}
-- stylua: ignore end

cmdline.setup({
	cmdline = {
		prompt = "  ",
	},
	popup = {
		relative = "editor",
		position = {
			row = "20%",
			col = "50%",
		},
		size = {
			width = 60,
		},
		border = {
			padding = {
				left = 1,
				right = 1,
			},
			text = {
				top = " cmd ",
				top_align = "left",
			},
			style = borderStyle,
		},
		win_options = {
			-- winhighlight = "Normal:NormalSB,FloatBorder:FloatBorder",
		},
	},
})

local can_close = false
vim.keymap.set("n", "<space><CR>", function()
	can_close = true
	cmdline.open({ default_value = "" })
end, { noremap = true })

vim.api.nvim_create_autocmd({ "FocusLost" }, {
	callback = function()
		if can_close then
			cmdline.fn.close()
		end
	end,
})
