local chezmoi = vim.api.nvim_create_augroup("chezmoi", {})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
	desc = "Prevent edits to files managed by chezoi",
	pattern = { "*.sh", "*.lua", "*.fish", "*.conf", "*.yml", "*.ini", "*.toml", ".gitconfig", "*.md" },
	group = chezmoi,
	callback = function()
		local filepath = vim.fn.expand "%:p"
		local handle = io.popen(string.format("chezmoi source-path %s", filepath))
		if handle == nil then
			return
		end
		local output = handle:read "*all"

		if output ~= "" then
			local status = os.execute "chezmoi --version"
			if status then
				Notify.warn "This file is managed by chezmoi"
			end
		end
		handle:close()
	end,
})

local handle = io.popen "chezmoi source-path"
if handle == nil then
	return
end

local sourcepath = handle:read "*all"

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	desc = "Apply changes to source files to their destination",
	pattern = sourcepath,
	group = chezmoi,
	callback = function()
		local filepath = vim.fn.expand "%:p"
		local status = os.execute("chezmoi apply --source-path " .. filepath)
		if not status then
			Notify.error "Update to destionation failed"
		end
	end,
})
