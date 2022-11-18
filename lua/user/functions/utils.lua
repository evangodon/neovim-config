--
-- Module
--
local M = {}

-- Reload config
M.reloadConfig = function()
  -- Remove all autocmds
  vim.cmd [[autocmd!]]
  -- Certain packages complain when setup is called twice
  package.loaded["nvim-tree"] = nil
  package.loaded["which-key"] = nil

  -- My config
  for name, _ in pairs(package.loaded) do
    if name:match "^user." or name:match "^plugins." then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
  require("notify").notify "Reloaded config"
end

local status_ok, wk = pcall(require, "which-key")
if not status_ok then
  return
end

-- Set leader keymappings
M.leaderKeymaps = function(keys, opts)
  local defaults = vim.tbl_extend("keep", { prefix = "<leader>" }, opts or {})
  wk.register(keys, defaults)
end

M.toggleVimOption = function(option)
  local current_state = vim.opt[option]:get()
  vim.opt[option] = not current_state
  Notify.info((current_state and "Disabled" or "Enabled") .. string.format(" option %s", option))
end

return M
