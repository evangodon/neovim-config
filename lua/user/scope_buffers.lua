local api = vim.api

-- Scope all buffers to their tab
local M = {}

M.cache = {}
M.last_tab = 0

function M.on_tab_new_entered()
  vim.bo[0].buflisted = true
end

function M.on_tab_enter()
  local tab = vim.api.nvim_get_current_tabpage()
  local buf_nums = M.cache[tab]
  if buf_nums then
    for _, k in pairs(buf_nums) do
      vim.bo[k].buflisted = true
    end
  end
end

function M.on_tab_leave()
  local tab = vim.api.nvim_get_current_tabpage()
  local buf_nums = Get_loaded_buffers()
  M.cache[tab] = buf_nums
  for _, k in pairs(buf_nums) do
    vim.bo[k].buflisted = true
  end
  M.last_tab = tab
end

function M.on_tab_closed()
  M.cache[M.last_tab] = nil
end

function M.print_summary()
  print("tab" .. " " .. "buf" .. " " .. "name")
  for tab, buf_item in pairs(M.cache) do
    for _, buf in pairs(buf_item) do
      local name = vim.api.nvim_buf_get_name(buf)
      print(tab .. " " .. buf .. " " .. name)
    end
  end
end

function M.setup()
  local group = api.nvim_create_augroup("ScopeAU", {})
  api.nvim_create_autocmd("TabEnter", { group = group, callback = M.on_tab_enter })
  api.nvim_create_autocmd("TabLeave", { group = group, callback = M.on_tab_leave })
  api.nvim_create_autocmd("TabClosed", { group = group, callback = M.on_tab_closed })
  api.nvim_create_autocmd("TabNewEntered", { group = group, callback = M.on_tab_new_entered })
  api.nvim_create_user_command("ScopeList", M.print_summary, {})
end

M.setup()

return M
