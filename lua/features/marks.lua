--- Custom mark API that renders marks as extmarks so the signs follow edited lines.

local strings = require "util.string"

local M = {}

local group_name = "user_marks"
local ns = vim.api.nvim_create_namespace(group_name)

---@class FeaturesMarksEntry
---@field line integer
---@field id integer

--- Mark information per buffer.
---@type table<integer, table<string, FeaturesMarksEntry>>
local marks = {}

---@param mark string
---@return boolean
local function is_lowercase_mark(mark)
  return 97 <= mark:byte() and mark:byte() <= 122
end

---@param mark string
---@return boolean
local function is_uppercase_mark(mark)
  return 65 <= mark:byte() and mark:byte() <= 90
end

---@param mark string
---@return boolean
local function is_letter_mark(mark)
  return is_lowercase_mark(mark) or is_uppercase_mark(mark)
end

---@param mark string
---@param bufnr integer
---@return nil
local function delete_mark(mark, bufnr)
  local buffer_marks = marks[bufnr]
  if not buffer_marks or not buffer_marks[mark] then
    return
  end

  vim.api.nvim_buf_del_extmark(bufnr, ns, buffer_marks[mark].id)
  buffer_marks[mark] = nil

  vim.cmd("delmarks " .. mark)
end

---@param mark string
---@param bufnr integer
---@param line? integer
---@return nil
local function register_mark(mark, bufnr, line)
  local buffer_marks = marks[bufnr]
  if not buffer_marks then
    return
  end

  if buffer_marks[mark] then
    delete_mark(mark, bufnr)
  end

  line = line or vim.api.nvim_win_get_cursor(0)[1]
  local id = vim.api.nvim_buf_set_extmark(bufnr, ns, line - 1, 0, {
    sign_text = strings.superscript(mark),
    sign_hl_group = "DiagnosticSignOk",
    priority = 10,
    strict = false,
  })

  buffer_marks[mark] = { line = line, id = id }
end

---@return string?
local function read_letter_mark()
  local ok, mark = pcall(vim.fn.getcharstr)
  if ok and is_letter_mark(mark) then
    return mark
  end
end

---@param bufnr integer
---@return nil
local function set_keymaps(bufnr)
  vim.keymap.set("n", "m", function()
    local mark = read_letter_mark()
    if mark then
      register_mark(mark, bufnr)
      vim.cmd("normal! m" .. mark)
    end
  end, { buffer = bufnr, desc = "Add mark" })

  vim.keymap.set("n", "dm", function()
    local mark = read_letter_mark()
    if mark then
      delete_mark(mark, bufnr)
    end
  end, { buffer = bufnr, desc = "Delete mark" })

  vim.keymap.set("n", "dm-", function()
    marks[bufnr] = {}
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
    vim.cmd "delmarks!"
  end, { buffer = bufnr, desc = "Delete all buffer marks" })
end

--- Refresh the signs whenever a buffer is shown in a window.
---@param bufnr integer
---@return nil
local function refresh(bufnr)
  if vim.bo[bufnr].buftype ~= "" then
    return
  end

  set_keymaps(bufnr)
  marks[bufnr] = marks[bufnr] or {}

  for mark, _ in pairs(marks[bufnr]) do
    if vim.api.nvim_buf_get_mark(bufnr, mark)[1] == 0 then
      delete_mark(mark, bufnr)
    end
  end

  for _, data in ipairs(vim.fn.getmarklist()) do
    local mark = data.mark:sub(2, 3)
    local mark_buf = data.pos[1]
    local mark_line = data.pos[2]
    local cached_mark = marks[bufnr][mark]

    if mark_buf == bufnr and is_uppercase_mark(mark) and (not cached_mark or mark_line ~= cached_mark.line) then
      register_mark(mark, bufnr, mark_line)
    end
  end

  -- getmarklist("%") is correct here; the generated type only accepts an integer.
  ---@diagnostic disable-next-line: param-type-mismatch
  for _, data in ipairs(vim.fn.getmarklist "%") do
    local mark = data.mark:sub(2, 3)
    local mark_line = data.pos[2]
    local cached_mark = marks[bufnr][mark]

    if is_lowercase_mark(mark) and (not cached_mark or mark_line ~= cached_mark.line) then
      register_mark(mark, bufnr, mark_line)
    end
  end
end

--- Register the mark autocommand group.
---@return nil
function M.setup()
  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = vim.api.nvim_create_augroup(group_name, { clear = true }),
    callback = function(args)
      refresh(args.buf)
    end,
  })
end

return M
