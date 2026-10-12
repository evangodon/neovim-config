-- Report WCAG contrast ratios for the resolved Catppuccin palettes.
--
-- Run from anywhere:
--   NVIM_APPNAME=nvim-2027 bob run nightly --headless \
--     "+lua dofile(vim.fn.stdpath('config') .. '/scripts/contrast_checker.lua')" '+qa!'
--
-- Reads the palette through catppuccin itself, so it reports the colours that actually render,
-- including the custom overrides.

local AA_TEXT = 4.5
local AA_LARGE = 3.0

---@param channel integer
---@return number
local function linearize(channel)
  local c = channel / 255
  if c <= 0.03928 then
    return c / 12.92
  end

  return ((c + 0.055) / 1.055) ^ 2.4
end

---@param hex string
---@return number
local function luminance(hex)
  local r, g, b = hex:match "#(%x%x)(%x%x)(%x%x)"
  if not r then
    return 0
  end

  return 0.2126 * linearize(tonumber(r, 16)) + 0.7152 * linearize(tonumber(g, 16)) + 0.0722 * linearize(tonumber(b, 16))
end

---@param a string
---@param b string
---@return number
local function contrast(a, b)
  local la, lb = luminance(a), luminance(b)
  local lighter, darker = math.max(la, lb), math.min(la, lb)

  return (lighter + 0.05) / (darker + 0.05)
end

---@param ratio number
---@return string
local function verdict(ratio)
  if ratio >= AA_TEXT then
    return "AA text"
  end

  if ratio >= AA_LARGE then
    return "AA large"
  end

  return "FAIL"
end

--- Backgrounds are meant to sit close to the base, so they are reported separately.
---@type table<string, boolean>
local BACKGROUNDS = {
  base = true,
  mantle = true,
  crust = true,
  surface0 = true,
  surface1 = true,
  surface2 = true,
}

---@param flavour string
---@return nil
local function report(flavour)
  local palette = require("catppuccin.palettes").get_palette(flavour)
  local base = palette.base

  ---@type { name: string, hex: string, ratio: number }[]
  local foregrounds = {}
  ---@type { name: string, hex: string, ratio: number }[]
  local backgrounds = {}

  for name, hex in pairs(palette) do
    if type(hex) == "string" and hex:match "^#%x%x%x%x%x%x$" then
      local row = { name = name, hex = hex, ratio = contrast(hex, base) }
      table.insert(BACKGROUNDS[name] and backgrounds or foregrounds, row)
    end
  end

  ---@param a { ratio: number }
  ---@param b { ratio: number }
  ---@return boolean
  local function by_ratio(a, b)
    return a.ratio < b.ratio
  end

  table.sort(foregrounds, by_ratio)
  table.sort(backgrounds, by_ratio)

  print(string.format("\n== %s, foreground contrast against base %s", flavour, base))
  print(string.format("%-11s %-9s %6s  %s", "name", "hex", "ratio", "verdict"))

  local failures = 0
  for _, row in ipairs(foregrounds) do
    if row.ratio < AA_LARGE then
      failures = failures + 1
    end
    print(string.format("%-11s %-9s %6.2f  %s", row.name, row.hex, row.ratio, verdict(row.ratio)))
  end

  print(string.format("foregrounds below the %.1f threshold: %d of %d", AA_LARGE, failures, #foregrounds))
  print(string.format("backgrounds, expected near 1.0: %s", backgrounds[1].name))

  for _, row in ipairs(backgrounds) do
    print(string.format("  %-9s %-9s %6.2f", row.name, row.hex, row.ratio))
  end
end

for _, flavour in ipairs({ "latte", "mocha" }) do
  report(flavour)
end
