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

  local command = string.format("presenterm --config-file ~/.config/presenterm/config.yaml %s", path)
  kitty.launch(command)
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

-- Get path to daily log and open it
vim.api.nvim_create_user_command("ZkDaily", function()
  local work_notes_dir_var = "$WORK_NOTES_DIR"
  local work_notes_dir = vim.fn.expand(work_notes_dir_var)
  if work_notes_dir == "" or work_notes_dir == work_notes_dir_var then
    Notify.error(work_notes_dir_var .. "variable is not set")
    return
  end

  local cmd =
    string.format('zk new --no-input --working-dir="%s" --group "daily" "./Log/daily" --print-path', work_notes_dir)

  local output = vim.fn.system(cmd):gsub("%s+$", "")

  vim.cmd("edit " .. vim.fn.fnameescape(output))
end, { nargs = 0 })
