local M = {
  "romgrk/barbar.nvim",
  event = "VeryLazy",
}

function M.config()
  local bufferline = require "bufferline"

  bufferline.setup({
    animation = false,
    icon_separator_active = "▓",
    icon_separator_inactive = "▓",
    icon_pinned = "車",
    letters = "asdfjklghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",
  })
end

function M.init()
  local nvim_tree_events = require "nvim-tree.events"
  local bufferline_api = require "bufferline.api"
  local fn = require "user.functions"

  local function get_tree_size()
    return require("nvim-tree.view").View.width
  end

  nvim_tree_events.subscribe("TreeOpen", function()
    bufferline_api.set_offset(get_tree_size() + 1)
  end)

  nvim_tree_events.subscribe("Resize", function()
    bufferline_api.set_offset(get_tree_size() + 1)
  end)

  nvim_tree_events.subscribe("TreeClose", function()
    bufferline_api.set_offset(0)
  end)

  local keymap = vim.keymap.set
  local opts = { noremap = true, silent = true }

  keymap("n", "[B", CMD "BufferMovePrev", opts)
  keymap("n", "]B", CMD "BufferMoveNext", opts)
  keymap("n", "<leader>\\", CMD "BufferPick", opts)

  fn.register_key_map({
    B = {
      CMD "BufferCloseAllButCurrent",
      "Close all buffers but current",
    },
  })
end

return M
