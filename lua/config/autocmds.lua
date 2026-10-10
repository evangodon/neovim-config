local group = vim.api.nvim_create_augroup("config", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.hl.hl_op({ higroup = "Search", timeout = 400 })
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  desc = "Return to last cursor position on enter",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.cmd [[normal! g`"zz]]
    end
  end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  group = group,
  desc = "Remove search highlighting when entering insert mode",
  callback = function()
    vim.cmd.nohlsearch()
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = {
    "qf",
    "help",
    "man",
    "notify",
    "lspinfo",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
})

-- Close quickfix menu after selecting choice
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "qf",
  callback = function(event)
    vim.keymap.set("n", "<CR>", "<CR>:cclose<CR>", { buffer = event.buf, silent = true, noremap = true })
  end,
})

-- Add color highlighting to .rasi files (the config for rofi)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = group,
  pattern = { "*.rasi", "*.rasi.tmpl" },
  command = "set filetype=css",
})

-- When using the tmpl files for Chezmoi, change the file type to the destination file type
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = group,
  pattern = "*.*.tmpl",
  callback = function()
    local filename = vim.fn.expand "%:t"
    if filename:match "^.*%.rasi%.tmpl$" then
      return
    end

    local filetype = filename:match "^.*%.(.*)%.tmpl$"
    if filetype then
      vim.bo.filetype = filetype
    end
  end,
})
