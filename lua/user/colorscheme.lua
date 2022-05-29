local hour = tonumber(os.date "%H")
local is_day = hour < 19 and hour > 6

local LIGHT_THEME = "github_light_default"
local DARK_THEME = "embark"

local colorscheme = is_day and LIGHT_THEME or DARK_THEME

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not status_ok then
	vim.notify("colorscheme " .. colorscheme .. " not found!")
	return
end
