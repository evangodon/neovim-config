-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- vim.cmd [[
--   augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost plugins/init.lua source <afile> | PackerSync
--   augroup end
-- ]]

-- Hightlight on yank
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 400 })
	end,
})

-- Clear command line message after a few seconds
local cmdline_timer = vim.loop.new_timer()
local message_duration = 4000
vim.api.nvim_create_autocmd({ "CmdlineLeave" }, {
	callback = function()
		cmdline_timer:start(
			message_duration,
			0,
			vim.schedule_wrap(function()
				vim.notify ""
			end)
		)
	end,
})

vim.api.nvim_create_autocmd({ "CmdwinEnter", "CmdlineEnter" }, {
	callback = function()
		cmdline_timer:stop()
	end,
})

vim.api.nvim_create_autocmd({ "BufDelete" }, {
	callback = function()
		local loaded_buffers = vim.tbl_filter(function(buf)
			return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, "buflisted")
		end, vim.api.nvim_list_bufs())

		if #loaded_buffers == 2 and vim.fn.expand "%" == "" then
			local yes, no = "yes", "no"
			vim.ui.select({ yes, no }, {
				prompt = "Quit Neovim?",
			}, function(choice)
				if not choice then
					return
				end
				if choice == yes then
					vim.cmd "quitall"
				else
					-- open Dashboard here
				end
			end)
		end
	end,
})
