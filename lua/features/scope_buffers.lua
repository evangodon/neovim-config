--- Scopes listed buffers to the tab they were opened in.

local buffers = require "util.buffer"

local M = {}

---@type table<integer, integer[]>
M.cache = {}

---@type integer
M.last_tab = 0

---@return nil
function M.on_tab_new_entered()
  vim.bo[0].buflisted = true
end

---@return nil
function M.on_tab_enter()
  local tab = vim.api.nvim_get_current_tabpage()
  local buf_nums = M.cache[tab]
  if not buf_nums then
    return
  end

  for _, buf in ipairs(buf_nums) do
    if vim.api.nvim_buf_is_valid(buf) then
      vim.bo[buf].buflisted = true
    end
  end
end

---@return nil
function M.on_tab_leave()
  local tab = vim.api.nvim_get_current_tabpage()
  local buf_nums = buffers.listed()
  M.cache[tab] = buf_nums

  for _, buf in ipairs(buf_nums) do
    if vim.api.nvim_buf_is_valid(buf) then
      vim.bo[buf].buflisted = false
    end
  end

  M.last_tab = tab
end

---@return nil
function M.on_tab_closed()
  M.cache[M.last_tab] = nil
end

---@return nil
function M.print_summary()
  print "tab buf name"
  for tab, buf_nums in pairs(M.cache) do
    for _, buf in ipairs(buf_nums) do
      print(tab .. " " .. buf .. " " .. vim.api.nvim_buf_get_name(buf))
    end
  end
end

--- Register the tab-scoping autocommands.
---@return nil
function M.setup()
  local group = vim.api.nvim_create_augroup("ScopeAU", { clear = true })
  vim.api.nvim_create_autocmd("TabEnter", { group = group, callback = M.on_tab_enter })
  vim.api.nvim_create_autocmd("TabLeave", { group = group, callback = M.on_tab_leave })
  vim.api.nvim_create_autocmd("TabClosed", { group = group, callback = M.on_tab_closed })
  vim.api.nvim_create_autocmd("TabNewEntered", { group = group, callback = M.on_tab_new_entered })
  vim.api.nvim_create_user_command("ScopeList", M.print_summary, {})
end

return M
