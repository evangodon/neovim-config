local status_ok, autosession = pcall(require, "nvim-autopairs")
if not status_ok then
	return
end

autosession.setup({})
