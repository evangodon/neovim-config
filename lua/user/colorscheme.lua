local hour = tonumber(os.date "%H")
local dark_theme_env_var = os.getenv "NVIM_USE_DARK_THEME"
local use_light_theme = hour < 16 and hour > 6
if dark_theme_env_var then
  local stringToBool = { ["true"] = true, ["false"] = false }
  use_light_theme = not stringToBool[dark_theme_env_var]
end

local themes = {
  -- Catppuccin
  catppuccinLatte = "catppuccin-latte",
  catppuccinFrappe = "catppuccin-frappe",
  catppuccinMacchiato = "catppuccin-macchiato",
  catppuccinMocha = "catppuccin-mocha",

  dayfox = "dayfox",
  dawnfox = "dawnfox",
  duskfox = "duskfox",
  nightfox = "nightfox",
  carbonfox = "carbonfox",
}

local LIGHT_THEME = themes.catppuccinLatte
local DARK_THEME = themes.nightfox

local colorscheme = use_light_theme and LIGHT_THEME or DARK_THEME

-- Set colorscheme
local status_ok, _ = pcall(vim.cmd.colorscheme, colorscheme)

if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end

require("user.functions").registerKeyMap({
  C = {
    CMD "Telescope colorscheme",
    "Telescope [c]olorschemes",
  },
})
