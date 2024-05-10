local M = {
  "nanozuki/tabby.nvim",
  dependencies = {
    "cbochs/grapple.nvim",
  },
  lazy = false,
}

local function pad(str, length)
  local padding = string.rep(" ", (length - #str) / 2)
  return padding .. str .. padding
end

local function cwd()
  local f = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  f = " " .. f
  f = pad(f, 18)
  return f
end

local function get_grapple_key(bufid)
  local key = require("grapple").find({ buffer = bufid })
  if key == nil then
    return ""
  end

  return key
end

local theme = {
  fill = "TabLineFill",
  head = "TabLineSel",
  current_tab = "TabLineSel",
  tab = "TabLine",
  win = "TabLine",
  tail = "TabLine",
}

local function split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

--[[ local sep = {
  right = "",
  left = "",
} ]]
function M.config()
  local utils = require "user.functions.utils"
  local tabby_utils = require "tabby.util"

  local function shortenPath(buf_path)
    local relativeToCurDir = vim.fn.fnamemodify(buf_path, ":.")
    local head = vim.fn.fnamemodify(relativeToCurDir, ":h")
    local tail = vim.fn.fnamemodify(buf_path, ":t")

    local path_segments = split(head, "/")
    local length = #path_segments

    local path = ""
    if path_segments[length] ~= nil then
      path = path_segments[length] .. "/"
    end
    if path_segments[length - 1] ~= nil then
      path = path .. path_segments[length - 1] .. "/"
    end

    return path .. tail
  end

  local components = function()
    local space = {
      type = "text",
      text = {
        " ",
        hl = "TabLineFill",
      },
    }
    local spring = { type = "spring" }

    -- HEAD
    local head = {
      type = "text",
      text = {
        cwd(),
        hl = theme.head,
      },
    }

    local parts = {
      head,
      space,
    }

    -- TABS
    local tabs = vim.api.nvim_list_tabpages()
    if #tabs > 1 then
      local current_tab = vim.api.nvim_get_current_tabpage()
      for _, tabid in ipairs(tabs) do
        local is_current_tab = tabid == current_tab
        local tab_name = tabby_utils.get_tab_name(tabid, function()
          return tabid
        end)
        local icon = is_current_tab and "" or ""
        table.insert(parts, {
          type = "tab",
          tabid = tabid,
          label = {
            string.format(" %s %s ", icon, tab_name),
            hl = theme.fill,
          },
        })
      end
    end

    table.insert(parts, spring)

    -- BUFFERS
    local cur_bufid = vim.api.nvim_get_current_buf()
    -- local buffers = vim.fn.tabpagebuflist()
    local buffers = vim.api.nvim_list_bufs()
    local buf_names = {}
    -- Keep track of buffer names to check for duplicates
    for _, bufid in ipairs(buffers) do
      if vim.api.nvim_buf_is_valid(bufid) and vim.bo[bufid].buflisted then
        local buf_path = vim.api.nvim_buf_get_name(bufid)
        local name = vim.fn.fnamemodify(buf_path, ":t")
        buf_names[name] = buf_names[name] == nil and 1 or buf_names[name] + 1
      end
    end

    for _, bufid in ipairs(buffers) do
      if vim.api.nvim_buf_is_valid(bufid) and vim.bo[bufid].buflisted then
        local is_active = bufid == cur_bufid
        local hl = is_active and theme.current_tab or theme.tab
        local buf_path = vim.api.nvim_buf_get_name(bufid)
        if buf_path == "" then
          buf_path = "[No Name]"
        end
        local buffer_name = ""
        local buf_name = vim.fn.fnamemodify(buf_path, ":t")
        if buf_names[buf_name] == 1 then
          buffer_name = buf_name
        else
          buffer_name = shortenPath(buf_path)
        end
        local grapple_key = get_grapple_key(bufid)
        local grapple_key_sup = utils.get_superscript(grapple_key)
        local icon = is_active and "" or ""
        local is_modified = vim.api.nvim_buf_get_option(bufid, "modified") and "● " or ""

        table.insert(parts, space)
        table.insert(parts, {
          type = "text",
          text = {
            string.format(" %s %s%s %s", icon, buffer_name, grapple_key_sup, is_modified),
            hl = hl,
          },
        })
      end
    end

    table.insert(parts, space)
    table.insert(parts, spring)

    return parts
  end

  require("tabby").setup({
    components = components,
  })
end

return M
