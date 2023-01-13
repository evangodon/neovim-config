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
  Notify.info "Reloaded config"
end

-- Set leader keymappings
M.register_key_map = function(keys, opts)
  local defaults = vim.tbl_extend("keep", { prefix = "<leader>" }, opts or {})
  local wk = require "which-key"
  wk.register(keys, defaults)
end

function M.toggle_option(option)
  return function()
    local current_state = vim.opt[option]:get()
    vim.opt[option] = not current_state
    Notify.info((current_state and "Disabled" or "Enabled") .. string.format(" option %s", option))
  end
end

function M.get_color(group, attr)
  local fn = vim.fn
  return fn.synIDattr(fn.synIDtrans(fn.hlID(group)), attr)
end

return M
