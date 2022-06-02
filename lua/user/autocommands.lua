-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- vim.cmd [[
--   augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost plugins/init.lua source <afile> | PackerSync
--   augroup end
-- ]]

-- Clear command line message
local timer = vim.loop.new_timer()
local message_duration = 4000
vim.api.nvim_create_autocmd({ "CmdlineLeave" }, {
	callback = function()
		timer:start(
			message_duration,
			0,
			vim.schedule_wrap(function()
				vim.notify ""
			end)
		)
	end,
})

vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
	callback = function()
		timer:stop()
	end,
})
