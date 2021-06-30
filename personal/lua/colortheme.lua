

--Change theme depending on the time of day
local hour = tonumber(os.date("%H"))
local is_day = hour < 20 and hour > 6

vim.api.nvim_set_var('is_day', is_day)

vim.cmd[[colorscheme embark]]

if is_day then
  vim.o.background = "light"
  vim.cmd[[colorscheme one]]
else
  vim.cmd[[colorscheme embark]]
end


