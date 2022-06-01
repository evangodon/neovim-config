local status_ok, go = pcall(require, "go")
if not status_ok then
	return
end

go.setup()

local wk_status_ok, wk = pcall(require, "which-key")
if not wk_status_ok then
	return
end

wk.register({
	g = {
		f = { ":GoFillStruct<cr>", "Fill struct" },
	},
}, { prefix = "<leader>" })
