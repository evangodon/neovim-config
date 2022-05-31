local M = {}

-- Reload config
local reloadConfig = function()
	for name, _ in pairs(package.loaded) do
		if name:match "^user." or name:match "^plugins." then
			package.loaded[name] = nil
		end
	end

	dofile(vim.env.MYVIMRC)
	require("notify").notify "Reloaded config"
end

M.reloadConfig = reloadConfig

return M
