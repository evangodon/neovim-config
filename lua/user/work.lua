-- Anything specific to a company codebase will go here
--

local wk = require "which-key"
local utils = require "user.functions.utils"
local floating_window = require "user.functions.floating_window"
local kitty = require "user.functions.kitty"

wk.add({
  { LeaderKey "x", group = "X-Series" },
  {
    LeaderKey "xs",
    function()
      local function on_window_open(buf)
        local keymap_options = { buffer = buf, noremap = true, silent = true }
        vim.keymap.set("n", "h", "<Nop>", keymap_options)
        vim.keymap.set("n", "l", "<Nop>", keymap_options)
        -- Unswap a permission by pressing key
        vim.keymap.set("n", "u", function()
          local service = vim.fn.expand "<cword>"
          local cmd = string.format("nobob unswap %s", service)
          local output = vim.fn.systemlist(cmd)

          local clean_output = utils.strip_ansi_codes(output)

          vim.bo[buf].modifiable = true
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, clean_output)
          vim.bo[buf].modifiable = false
        end, keymap_options)
      end

      floating_window.with_output_from("nobob swapped", on_window_open)
    end,
    desc = "Open swapped services in floating window",
  },
  {
    LeaderKey "xd",
    function()
      kitty.launch("lazydocker", { cwd = "/Users/evan.godon/code/nobob" })
    end,
    desc = "View X-series containers in lazydocke",
  },
})
