local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

---@param desc string
local function optsWithDesc(desc)
  return { noremap = true, silent = true, desc = desc or "" }
end

-- Save
keymap("n", Ctrl "s", function()
  vim.cmd "silent! update"
end, { desc = "Save the file if modified", noremap = true, silent = true })

-- better window movement
keymap("n", Ctrl "h", "<C-w>h", opts)
keymap("n", Ctrl "j", "<C-w>j", opts)
keymap("n", Ctrl "k", "<C-w>k", opts)
keymap("n", Ctrl "l", "<C-w>l", opts)

-- resize with arrows
keymap("n", Ctrl "Up", Cmd "resize +3", opts)
keymap("n", Ctrl "Down", Cmd "resize -3", opts)
keymap("n", Ctrl "Left", Cmd "vertical resize +3", opts)
keymap("n", Ctrl "Right", Cmd "vertical resize -3", opts)

-- better indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Navigate buffers
keymap("n", "]b", vim.cmd "bnext", opts) -- Next buffer
keymap("n", Ctrl "n", Cmd "bnext", opts)
keymap("n", "<TAB>", Cmd "bnext", opts)
keymap("n", "[b", Cmd "bprevious", opts) -- Previous buffer
keymap("n", "<S-TAB>", Cmd "bprevious", opts)
keymap("n", "<BS>", Cmd "b#", opts)
keymap("n", "<leader>\\", Cmd "Telescope buffers", opts)

-- Duplicate a line and comment out the first line
keymap("n", "yc", function()
  vim.api.nvim_feedkeys("yygccp", "m", false)
end, optsWithDesc "Copy line and comment out the original")

-- Autocommand to set keymaps when entering a quickfix buffer
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    keymap("n", "<TAB>", Cmd "cnext", opts)
    keymap("n", "<S-TAB>", Cmd "cprev", opts)
  end,
})

vim.api.nvim_del_keymap("n", "<C-W>d")
vim.api.nvim_del_keymap("n", "<C-W><C-D>")
vim.api.nvim_create_user_command("CloseBuffer", function()
  local loaded_buffers = Get_loaded_buffers()
  if #loaded_buffers == 0 then
    return
  elseif #loaded_buffers == 1 then
    vim.cmd "confirm bdelete"
    vim.cmd "Alpha"
    vim.cmd "bdelete#"
  else
    vim.cmd "bprevious|confirm bdelete#"
  end
end, {})
keymap("n", "<C-w>", Cmd "CloseBuffer", opts)

-- Move selected line / block of text in visual mode
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- When going up or down one line, use displayed lines instead of physical lines
keymap("n", "k", "gk", opts)
keymap("n", "j", "gj", opts)
keymap("v", "k", "gk", opts)
keymap("v", "$", "g$", opts)

-- Navigate to beginning or ending of line
keymap("n", "H", "0", opts)
keymap("v", "H", "0", opts)
keymap("n", "L", "$", opts)
keymap("v", "L", "$", opts)

-- Start search and replace in visual mode
keymap("v", "f", ":s/", opts)

-- Prevent overiding the last yank when deleting empty line
keymap("n", "dd", function()
  return vim.api.nvim_get_current_line():match "^%s*$" and '"_dd' or "dd"
end, { expr = true, noremap = true })

keymap("", "<Space>", "<Nop>", opts)

-- Terminal
keymap("t", "<Esc><Esc>", [[<C-\><C-N> :q<CR>]], opts)

-- Disable recording
keymap("n", "Q", "<nop>", opts)
keymap("n", "q", "<nop>", opts)

-- Select workd
keymap("n", "<CR>", "viw", opts)

-- LSP
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(args)
    local telescope_pickers = require "telescope.builtin"
    local telescope_theme = require "telescope.themes"

    local bufnr = args.buf

    local telescope_ivy_theme = telescope_theme.get_ivy({
      layout_config = { height = 0.5 },
      initial_mode = "normal",
      preview_title = "Preview",
      show_line = true,
    })

    -- KEYMAPS
    local function setBufOpts(desc)
      return { noremap = true, silent = true, buffer = bufnr, desc = desc }
    end

    keymap("n", "gD", vim.lsp.buf.declaration, setBufOpts "Jump to declaration")
    keymap("n", "gd", vim.lsp.buf.definition, setBufOpts "Jump to definition")
    keymap("n", "gh", vim.lsp.buf.hover, setBufOpts "Hover")
    keymap("n", "gI", vim.lsp.buf.implementation, setBufOpts "Implementation")
    keymap("n", "gi", function()
      telescope_pickers.lsp_implementations(telescope_ivy_theme)
    end, setBufOpts "Implementation")
    keymap("n", "<C-k>", vim.lsp.buf.signature_help, setBufOpts "Signature help")
    keymap("n", "gr", function()
      telescope_pickers.lsp_references(telescope_ivy_theme)
    end, setBufOpts "Find references")
    keymap("n", "<F2>", vim.lsp.buf.rename, setBufOpts "Rename")
    keymap("n", "[d", function()
      vim.diagnostic.goto_prev({ border = "single" })
    end, setBufOpts "Jump to previous diagnostic")
    keymap("n", "gl", function()
      vim.diagnostic.open_float({ border = "single" })
    end, setBufOpts "Open diagnostics")
    keymap("n", "]d", function()
      vim.diagnostic.goto_next({ border = "single" })
    end, setBufOpts "Jump to next diagnostic")
  end,
})

-- Leader key mappings

local fn = require "user.functions.utils"
local wk = require "which-key"

wk.add({
  { LeaderKey "q", Cmd "quitall!", desc = "Force quit" },
  { LeaderKey "c", Cmd "close", desc = "Close window" },
  { LeaderKey "O", Cmd "OpenSlides", desc = "Open file in slides" },
  { LeaderKey "B", fn.close_all_buffers_but_current, desc = "Close all buffers but current" },
})

wk.add({
  { LeaderKey "T", group = "Toggle option" },
  { LeaderKey "Tc", fn.toggle_option "cursorcolumn", desc = "Toggle cursorcolumn" },
  { LeaderKey "Tr", fn.toggle_option "relativenumber", desc = "Toggle relativenumber" },
})
