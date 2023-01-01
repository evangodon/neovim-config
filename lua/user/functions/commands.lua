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
