-- TODO: Get chezmoi source dir
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = Home_dir .. "/.local/share/chezmoi/*",
	callback = function()
		vim.api.nvim_exec([[!chezmoi apply --source-path "%"]], true)
	end,
})
