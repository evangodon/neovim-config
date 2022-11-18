-- List of vim events:
-- https://tech.saigonist.com/b/code/list-all-vim-script-events.html
--
-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- vim.cmd [[
--   augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost plugins/init.lua source <afile> | PackerSync
--   augroup end
-- ]]

-- Hightlight on yank
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 400 })
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
        vim.notify ""
      end)
    )
  end,
})

vim.api.nvim_create_autocmd({ "CmdwinEnter", "CmdlineEnter" }, {
  callback = function()
    cmdline_timer:stop()
  end,
})

-- Confirm quit when closing last buffer
vim.api.nvim_create_autocmd({ "BufDelete" }, {
  callback = function()
    local loaded_buffers = vim.tbl_filter(function(buf)
      return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, "buflisted")
    end, vim.api.nvim_list_bufs())

    if #loaded_buffers == 2 and vim.fn.expand "%" == "" then
      local confirm, cancel = "Confirm", "Cancel"
      vim.ui.select({ confirm, cancel }, {
        prompt = "Quit Neovim?",
      }, function(choice)
        if not choice then
          return
        end
        if choice == confirm then
          vim.cmd "quitall"
        else
          vim.cmd ":bdelete"
        end
      end)
    end
  end,
})

-- Return to last cursor position on enter
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    vim.cmd [[silent! '"; normal z.]]
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
