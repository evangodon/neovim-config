--- Buffer helpers.
---
--- Replaces the old global `Get_loaded_buffers` function and the `close_all_buffers_but_current`
--- utility.

local M = {}

--- Return every valid, listed buffer handle.
---
--- The old helper was named `Get_loaded_buffers` but filtered on `buflisted`, so this reports the
--- buffers that appear in listings rather than every buffer that exists in memory.
---
---@return integer[]
function M.listed()
  return vim.tbl_filter(function(buf)
    if not buf or buf < 1 then
      return false
    end

    return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
  end, vim.api.nvim_list_bufs())
end

--- Delete every listed buffer except the current one.
---
--- Buffers with unsaved changes are left alone and reported, instead of failing the whole loop.
---
---@return nil
function M.close_all_but_current()
  local current = vim.api.nvim_get_current_buf()
  ---@type string[]
  local skipped = {}

  for _, buf in ipairs(M.listed()) do
    if buf ~= current and vim.api.nvim_buf_is_valid(buf) then
      if vim.bo[buf].modified then
        table.insert(skipped, vim.fn.bufname(buf))
      else
        vim.api.nvim_buf_delete(buf, {})
      end
    end
  end

  if #skipped > 0 then
    require("util.notify").warn("Kept modified buffers: " .. table.concat(skipped, ", "))
  end
end

return M
