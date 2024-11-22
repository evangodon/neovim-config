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

vim.api.nvim_create_user_command("OpenSlides", function()
  local kitty = require "user.functions.kitty"
  local path = vim.fn.expand "%:p"

  kitty.launch({ program = "slides", args = path })
end, { nargs = 0 })

vim.api.nvim_create_user_command("OpenTabNewWorkspace", function()
  local wp = require "workspaces"
  local workspaces = wp.get()

  local paths = {}
  for _, v in pairs(workspaces) do
    table.insert(paths, v["path"])
  end

  vim.ui.select(paths, {
    prompt = "Select a workspace:",
    format_item = function(item)
      return item
    end,
  }, function(path)
    vim.cmd "$tabnew | NvimTreeOpen"
    vim.cmd("tcd" .. path)
  end)
end, { nargs = 0 })

vim.api.nvim_create_user_command("HideUI", function()
  -- Hide lualine
  require("lualine").hide({
    place = { "statusline", "tabline", "winbar" },
    unhide = false,
  })

  -- Hide gitsigns
  require("gitsigns").toggle_signs(false)

  vim.cmd "ScrollbarHide"

  vim.o.laststatus = 0
  vim.o.showtabline = 0
  vim.o.relativenumber = false
end, { nargs = 0 })

-- Print all env values
vim.api.nvim_create_user_command("PrintEnvValues", function()
  require("user.env").printValues()
end, { nargs = 0 })
