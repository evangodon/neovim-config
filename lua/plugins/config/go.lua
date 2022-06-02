local status_ok, go = pcall(require, "go")
if not status_ok then
	vim.notify "error calling go module"
	return
end

go.setup()

local wk_status_ok, wk = pcall(require, "which-key")
if not wk_status_ok then
	return
end

wk.register({
	G = {
		f = { ":GoFillStruct<cr>", "Fill struct" },
	},
}, { prefix = "<leader>" })
