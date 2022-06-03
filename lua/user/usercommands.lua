-- Confirm quit when on last buffer
vim.api.nvim_create_user_command("CustomBufferDelete", function()
	local loaded_buffers = vim.tbl_filter(function(buf)
		return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, "buflisted")
	end, vim.api.nvim_list_bufs())

	local cancelled = false
	if #loaded_buffers == 1 then
		vim.ui.input({ prompt = "Quit Neovim? (y/n)" }, function(input)
			if input == "y" then
				vim.cmd "quit"
			else
				cancelled = true
			end
		end)
	end

	if cancelled then
		return
	end

	require("bufdelete").bufdelete(0, true)
end, {})
