local M = {}


-- Open program in kitty overlay
function M.launch(opts)
  opts = opts and opts or {}

  if opts.program == nil then
    Notify.error("No program was passed in")
    return
  end

  local program = opts.program
  local args = opts.args and opts.args or ""

  local cmd = string.format("kitty @ launch --cwd=current --type=overlay %s %s", program, args)
  local function print_stderr(_, data)
    if data[1] ~= "" then
      Notify.error(data[1])
    end
  end

  vim.fn.jobstart(cmd, { on_stderr = print_stderr })
end

return M
