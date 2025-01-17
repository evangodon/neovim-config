local M = {
  "nanozuki/tabby.nvim",
  dependencies = {
    "cbochs/grapple.nvim",
  },
  event = "VimEnter",
}

local function pad(str, length)
  local padding = string.rep(" ", (length - #str) / 2)
  return padding .. str .. padding
end

local function cwd()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
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
  local devicons = require "nvim-web-devicons"

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

  local function filterWindows(win)
    return not string.match(win.name(), "NvimTree")
  end

  local function lineFn(line)
    return {
      {
        { "   ", hl = theme.head },
        line.sep("", theme.head, theme.fill),
      },
      (#line.tabs().tabs > 1) and (line.tabs().foreach(function(tab)
        return {
          line.sep(" ", theme.win, theme.fill),
          tab.is_current() and "" or "",
          utils.all_nums_to_superscript(tab.number()),
          line.sep(" ", theme.win, theme.fill),
          hl = theme.fill,
          margin = "",
        }
      end)),
      line.spacer(),
      line.bufs(line.api.get_current_tab()).filter(filterWindows).foreach(function(buf)
        local hl = buf.is_current() and theme.current_tab or theme.tab
        local buf_name = buf.name()

        return {
          line.sep("", hl, theme.fill),
          buf.is_current() and "" or "",
          buf_name,
          buf.is_changed() and "•" or "",
          line.sep("", hl, theme.fill),
          hl = hl,
          margin = " ",
        }
      end),
      line.spacer(),
      hl = theme.fill,
    }
  end

  require("tabby").setup({
    line = lineFn,
  })
end

return M
