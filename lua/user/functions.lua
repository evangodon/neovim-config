local M = {}

-- Reload config
M.reloadConfig = function()
  -- Certain packages complain when setup is called twice
	package.loaded["nvim-tree"] = nil

  -- My config
	for name, _ in pairs(package.loaded) do
		if name:match "^user." or name:match "^plugins." then
			package.loaded[name] = nil
		end
	end

	dofile(vim.env.MYVIMRC)
	require("notify").notify "Reloaded config"
end

return M
