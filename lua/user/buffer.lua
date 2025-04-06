local M = {}
local api = vim.api

--- A wrapper class around a buffer
--- @class Buffer
--- @field buf integer
local Buffer = {}
Buffer.__index = Buffer

--- Creates a new Buffer object.
--- @param bufnr integer The buffer handle.
--- @rreturn Buffer The new Buffer object.
function Buffer:new(bufnr)
  local b = setmetatable({}, self)
  b.buf = bufnr
  return b
end

--- Gets the buffer handle.
--- @return integer The buffer handle.
function Buffer:id()
  return self.buf
end

--- Clears the content of the buffer.
function Buffer:clear()
  api.nvim_buf_set_lines(self.buf, 0, -1, false, {})
end

--- Sets content of buffer
--- @param content string[]
function Buffer:set_lines(content)
  api.nvim_buf_set_lines(self:id(), 0, -1, false, content)
end

--- Check if buffer is valid
function Buffer:is_valid()
  return api.nvim_buf_is_valid(self.buf)
end

--- Check if buffer is valid
--- @param  value boolean
function Buffer:set_is_modifiable(value)
  vim.bo[self:id()].modifiable = value
end

--- Adds a keymap to the buffer.
--- @param mode string The keymap mode (e.g., "n", "v", "i").
--- @param lhs string The left-hand side of the mapping (the key sequence).
--- @param rhs string The right-hand side of the mapping (command or Lua function).
--- @param opts table? Optional keymap options (e.g., { noremap = true, silent = true }).
function Buffer:set_keymap(mode, lhs, rhs, opts)
  local options = opts or {}
  api.nvim_buf_set_keymap(self.buf, mode, lhs, rhs, options)
end

--- Creates a new Neovim buffer with specified options.
--- @param name string The name of the buffer (optional).
--- @param required table Define if buffer is  set to the buffer list and is scratch
--- @param options table? A table of buffer options to set (optional).
--- @return Buffer The handle of the newly created buffer.
function M.create_buffer(name, required, options)
  if required == nil then
    error "Missing required param "
    return Buffer:new(0)
  end
  local listed = required.listed and required.listed or false
  local scratch = required.listed and required.listed or true
  local buf = api.nvim_create_buf(listed, scratch)
  local b = Buffer:new(buf)

  api.nvim_buf_set_name(buf, name)

  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].swapfile = false
  vim.bo[buf].buftype = "nofile"

  if options then
    for key, value in pairs(options) do
      vim.bo[buf][key] = value
    end
  end

  return b
end

return M
