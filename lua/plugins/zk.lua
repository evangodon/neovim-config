-- ZK
-- https://github.com/mickael-menu/zk
-- https://github.com/mickael-menu/zk-nvim
--
-- Install `zk` with `brew install zk` or `yay -S zk`
--
local M = {
  "mickael-menu/zk-nvim",
  ft = "markdown",
}

-- TODO: [ ] Improve the Add new note keymap so that it works in any notebook
-- TODO: [ ] Add keymaps for creating notes in visual mode

function M.config()
  local zk = require "zk"

  zk.setup({
    picker = "telescope",
    lsp = {
      config = {
        cmd = { "zk", "lsp" },
        name = "zk",
        on_attach = function(_, bufnr)
          local function setBufOpts(desc)
            return { noremap = true, silent = true, buffer = bufnr, desc = desc }
          end

          local keymap = vim.keymap.set

          keymap("n", "gh", vim.lsp.buf.hover, setBufOpts "Preview note")
          keymap("n", "<CR>", vim.lsp.buf.definition, setBufOpts "Go to note")
          keymap("n", "gd", vim.lsp.buf.definition, setBufOpts "Go to note")
          keymap("n", "gl", function()
            vim.diagnostic.open_float()
          end, setBufOpts "Open diagnostics")
        end,
      },
      -- automatically attach buffers in a zk notebook that match the given filetypes
      auto_attach = {
        enabled = true,
        filetypes = { "markdown" },
      },
    },
  })
end

function M.init()
  local zk = require "zk"
  local zk_util = require "zk.util"
  local fn = require "user.functions"

  -- Verify that the file is in a zk notebook
  local function fileIsInNotebook()
    local in_notebook = zk_util.notebook_root(vim.fn.expand "%:p") ~= nil
    if not in_notebook then
      Notify.warn "Not in a zk notebook"
      return false
    end
    return true
  end

  local wk = require "which-key"

  wk.add({
    { LeaderKey "z", group = "zk" },
  })
end

return M
