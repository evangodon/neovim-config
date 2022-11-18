local M = {}

-- Prevent overiding the last yank when deleting empty line
function M.smart_dd()
  if vim.api.nvim_get_current_line():match "^%s*$" then
    return '"_dd'
  else
    return "dd"
  end
end

return M
