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

  fn.register_key_map({
    z = {
      name = "zk",
      -- New Note
      n = {
        function()
          local in_notebook = fileIsInNotebook()
          if not in_notebook then
            return
          end
          vim.ui.select({ "media", "books", "none" }, {
            prompt = "Title",
            telescope = require("telescope.themes").get_cursor(),
            relative = "editor",
          }, function(selected)
            local group = selected
            if selected == "none" then
              group = ""
            end
            vim.ui.input(string.format("[%s] Enter title: ", group), function(input)
              local title = input
              zk.new({ title = title, group = group, dir = group })
            end)
          end)
        end,
        "New note",
      },
      -- Backlinks
      b = {
        CMD "ZkBacklinks",
        "View backlinks",
      },
      -- Open Note
      o = {
        function()
          local in_notebook = fileIsInNotebook()
          if not in_notebook then
            return
          end
          zk.edit({}, { title = "Zk Notes" })
        end,
        "Open note",
      },
      -- See Links
      l = {
        function()
          local in_notebook = fileIsInNotebook()
          if not in_notebook then
            return
          end
          local buffer = vim.api.nvim_buf_get_name(0)
          zk.edit({ linkedBy = { buffer } }, { title = "Zk Links" })
        end,
        "See links",
      },
    },
  })
end

return M
