-- List of vim events:
-- https://tech.saigonist.com/b/code/list-all-vim-script-events.html

-- Hightlight on yank
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank({ higroup = "Search", timeout = 400 })
  end,
})

-- Clear command line message after a few seconds
local cmdline_timer = vim.loop.new_timer()
local message_duration = 4000
vim.api.nvim_create_autocmd({ "CmdlineLeave" }, {
  callback = function()
    cmdline_timer:start(
      message_duration,
      0,
      vim.schedule_wrap(function()
        -- vim.notify ""
      end)
    )
  end,
})
vim.api.nvim_create_autocmd({ "CmdwinEnter", "CmdlineEnter" }, {
  callback = function()
    cmdline_timer:stop()
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Return to last cursor position on enter",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.cmd 'normal! g`"zz'
    end
  end,
})

local svelte_group = vim.api.nvim_create_augroup("custom-prettier", {})
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = svelte_group,
  pattern = { "*.svelte", "*.astro" },
  callback = function()
    vim.cmd ":silent !prettier --write %"
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
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
    vim.keymap.set("n", "q", Cmd "close", { buffer = event.buf, silent = true })
  end,
})

-- Close quickfix menu after selecting choice
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "qf" },
  callback = function(event)
    vim.keymap.set("n", "<CR>", "<CR>:cclose<CR>", { buffer = event.buf, silent = true, noremap = true })
  end,
})

-- Add color highlighting to .rasi files (the config for rofi)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.rasi", "*.rasi.tmpl" },
  command = "set filetype=css",
})

-- When using the tmpl files for Chezmoi, change the file type to the destination file type
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.*.tmpl" },
  callback = function()
    local is_rasi_tmpl = vim.fn.expand("%:t"):match "^.*%.rasi.tmpl$"
    if is_rasi_tmpl then
      return
    end

    local ft = vim.fn.expand("%:t"):match "^.*%.(.*)%.tmpl$"

    if ft then
      vim.bo.filetype = ft
    end
  end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  desc = "Remove hl search when entering Insert",
  callback = vim.schedule_wrap(function()
    vim.cmd.nohlsearch()
  end),
})
