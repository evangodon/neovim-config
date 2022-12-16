local status_ok, autosession = pcall(require, "auto-session")
if not status_ok then
	return
end

autosession.setup({})
