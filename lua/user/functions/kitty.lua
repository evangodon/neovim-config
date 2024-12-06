local M = {}

-- Open program in kitty overlay
--- @param command string
--- @param opts? { cwd?: string }
function M.launch(command, opts)
  opts = opts or {}
  local cwd = opts.cwd or "current"

  if command == nil then
    Notify.error "Command required for kitty launch"
    return
  end

  local cmd = string.format("kitty @ launch --cwd=%s --type=overlay %s", cwd, command)
  local function print_stderr(_, data)
    if data[1] ~= "" then
      Notify.error(data[1])
    end
  end

  vim.fn.jobstart(cmd, { on_stderr = print_stderr })
end

return M
