--- Highlight group helpers.

local M = {}

--- Return a color attribute for a highlight group, such as `"fg#"` or `"bg#"`.
---
---@param group string Highlight group name.
---@param attr string Attribute name understood by `synIDattr`, for example `"fg#"`.
---@return string
function M.get(group, attr)
  local fn = vim.fn
  return fn.synIDattr(fn.synIDtrans(fn.hlID(group)), attr)
end

return M
