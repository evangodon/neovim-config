local M = {
  "nanozuki/tabby.nvim",
  dependencies = {
    "cbochs/grapple.nvim",
  },
  lazy = false,
}

local cwd = function()
  return "  " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " "
end

local function get_grapple_key(bufid)
  local key = require("grapple").key({ buffer = bufid })
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

--[[ local sep = {
  right = "",
  left = "",
} ]]

function M.config()
  local utils = require "user.functions.utils"
  local tabby_utils = require "tabby.util"

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

    table.insert(parts, spring)

    -- BUFFERS
    local cur_bufid = vim.api.nvim_get_current_buf()
    -- local buffers = vim.fn.tabpagebuflist()
    local buffers = vim.api.nvim_list_bufs()

    for _, bufid in ipairs(buffers) do
      if vim.api.nvim_buf_is_valid(bufid) and vim.bo[bufid].buflisted then
        local is_active = bufid == cur_bufid
        local hl = is_active and theme.current_tab or theme.tab
        local buf_name = vim.api.nvim_buf_get_name(bufid)
        if buf_name == "" then
          buf_name = "[No Name]"
        end
        buf_name = vim.fn.fnamemodify(buf_name, ":t")
        local grapple_key = get_grapple_key(bufid)
        local grapple_key_sup = utils.get_superscript(grapple_key)
        local icon = is_active and "" or ""
        local is_modified = vim.api.nvim_buf_get_option(bufid, "modified") and "●" or ""

        table.insert(parts, {
          type = "text",
          text = {
            string.format(" %s %s%s %s ", icon, buf_name, grapple_key_sup, is_modified),
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
