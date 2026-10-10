--- Icon definitions shared by statusline and UI modules.
---
--- The old module also assigned a global `Icon` table that nothing read, so it is dropped.

local M = {}

M.diagnostics = {
  default = "•",
  light_shade = "▒",
}

return M
