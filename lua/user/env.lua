local M = {}

M.envValues = {}

local function readFile()
  local values = {}
  local envPath = vim.env.HOME .. "/.config/nvim/.env"

  local file = assert(io.open(envPath, "r"))

  for line in file:lines() do
    local key, value = string.match(line, '([%w_]*)="+(.+)"')
    values[key] = value
  end

  file:close()
  return values
end

local function prepareValues()
  if #M.envValues ~= 0 then
    return
  end
  local ok, values = pcall(readFile)
  if not ok then
    Notify.error("error reading env file" .. values)
    return ""
  end

  M.envValues = values
end

function M.printValues()
  prepareValues()
  P(M.envValues)
end

function M.get(key)
  prepareValues()

  local value = M.envValues[key]

  if value == nil then
    Notify.error(key .. " not found")
    return ""
  end

  return value
end

return M
