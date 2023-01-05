vim.api.nvim_create_user_command("Scratch", function()
	vim.cmd [[
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    "setlocal nobuflisted
    file scratch.md
    set filetype=markdown
  ]]
end, {})

-- Open help in new buffer
vim.api.nvim_create_user_command("Help", function(args)
	vim.cmd.help(args.args)
	vim.cmd.only()
end, { nargs = 1, complete = "help" })
