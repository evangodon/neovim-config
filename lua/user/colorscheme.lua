local hour = tonumber(os.date("%H"))
local is_day = hour < 19 and hour > 6

local LIGHT_THEME = "embark"
local DARK_THEME = "tokyonight"

local colorscheme = is_day and LIGHT_THEME or DARK_THEME

if is_day then
   vim.cmd [[set background=light]]
else
  vim.cmd [[set background=dark]]
end

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
