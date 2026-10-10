vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key mappings

-- Show every mapping that starts with the leader key
map("n", "<leader>?", function()
  require("util.keymap_popup").open()
end, { desc = "Show leader mappings" })

map("n", "<leader>q", "<cmd>quitall!<CR>", { desc = "Force quit" })
map("n", "<leader>c", "<cmd>close<CR>", { desc = "Close window" })
map("n", "<leader>B", function()
  require("util.buffer").close_all_but_current()
end, { desc = "Close all buffers but current" })

---@param lhs string
---@param option string
---@param description string
---@return nil
local function toggle_option(lhs, option, description)
  map("n", lhs, function()
    ---@diagnostic disable-next-line: assign-type-mismatch
    vim.opt[option] = not vim.opt[option]:get()
  end, { desc = "Toggle " .. description })
end

-- Toggle option
toggle_option("<leader>Tc", "cursorcolumn", "cursorcolumn")
toggle_option("<leader>Tr", "relativenumber", "relativenumber")

-- Save
map("n", "<C-s>", function()
  vim.cmd "silent! update"
end, { desc = "Save the file if modified", noremap = true, silent = true })

-- better window movement
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- resize with arrows
map("n", "<C-Up>", ":resize +3<CR>", opts)
map("n", "<C-Down>", ":resize -3<CR>", opts)
map("n", "<C-Left>", ":vertical resize +3<CR>", opts)
map("n", "<C-Right>", ":vertical resize -3<CR>", opts)

-- better indenting
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Delete without sending selection to default register
map({ "x", "v" }, "<Del>", '"_di', { noremap = true, silent = true, desc = "delete without copying" })

-- Navigate buffers
map("n", "]b", "<cmd>bnext<CR>", opts)
map("n", "<C-n>", "<cmd>bnext<CR>", opts)
map("n", "<TAB>", "<cmd>bnext<CR>", opts)
map("n", "[b", "<cmd>bprevious<CR>", opts)
map("n", "<S-TAB>", "<cmd>bprevious<CR>", opts)

map("n", "<Del>", function()
  local last_buf = vim.fn.bufnr "#"
  local last_buf_ft = vim.bo[last_buf].filetype

  if last_buf ~= -1 and last_buf_ft ~= "NvimTree" then
    vim.cmd "b#"
  end
end, { noremap = true, silent = true, desc = "Switch to last buffer, but not NvimTree" })

-- Autocommand to set keymaps when entering a quickfix buffer
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function(args)
    map("n", "<TAB>", "<cmd>cnext<CR>", { buffer = args.buf, noremap = true, silent = true })
    map("n", "<S-TAB>", "<cmd>cprev<CR>", { buffer = args.buf, noremap = true, silent = true })
  end,
})

pcall(vim.keymap.del, "n", "<C-W>d")
pcall(vim.keymap.del, "n", "<C-W><C-D>")

-- Move selected line / block of text in visual mode
map("x", "K", ":move '<-2<CR>gv-gv", opts)
map("x", "J", ":move '>+1<CR>gv-gv", opts)

-- Move text up and down
map("v", "<A-j>", ":m .+1<CR>==", opts)
map("v", "<A-k>", ":m .-2<CR>==", opts)
map("v", "p", '"_dP', opts)

-- When going up or down one line, use displayed lines instead of physical lines
map("n", "k", "gk", opts)
map("n", "j", "gj", opts)
map("v", "k", "gk", opts)
map("v", "$", "g$", opts)

-- Navigate to beginning or ending of line
map("n", "H", "0", opts)
map("v", "H", "0", opts)
map("n", "L", "$", opts)
map("v", "L", "$", opts)

-- Start search and replace in visual mode
map("v", "f", ":s/", opts)

-- Prevent overiding the last yank when deleting empty line
map("n", "dd", function()
  return vim.api.nvim_get_current_line():match "^%s*$" and '"_dd' or "dd"
end, { expr = true, noremap = true })

map("", "<Space>", "<Nop>", opts)

-- Terminal
map("t", "<Esc><Esc>", [[<C-\><C-N> :q<CR>]], opts)

-- Disable recording
map("n", "Q", "<nop>", opts)
map("n", "q", "<nop>", opts)

-- Select word
map("n", "<CR>", "viw", opts)
