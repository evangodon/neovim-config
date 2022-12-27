local M = {}

M.envValues = {}

function M.prepareValues()
  if #M.envValues ~= 0 then
    return
  end
  local file = assert(io.open(".env", "r"))

  for line in file:lines() do
    local key, value = string.match(line, '([%w_]*)="+(.+)"')
    M.envValues[key] = value
  end

  file:close()
end

function M.printValues()
  M.prepareValues()
  P(M.envValues)
end

function M.get(key)
  local ok, envValues = pcall(M.prepareValues)
  if not ok then
    Notify.error ".env file not found"
    return ""
  end

  local value = envValues[key]

  if value == nil then
    Notify.error(key .. " not found")
    return ""
  end

  return value
end

return M
