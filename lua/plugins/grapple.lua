local backslash = [[\]]
local jump_leader = "<leader>j"

local M = {
  "cbochs/grapple.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "folke/which-key.nvim" },
  keys = { backslash, jump_leader },
}

function M.config()
  require("grapple").setup({
    log_level = "warn",
    scope = "git",
    popup_options = {
      relative = "editor",
      width = 60,
      height = 12,
      style = "minimal",
      focusable = false,
      border = "single",
    },

    integrations = {
      resession = false,
    },
  })
end

local function register_key_map(key, action, desc)
  local whichkey = require "which-key"
  local rhs = action == "<Nop>" and "which_key_ignore" or { action, desc }
  key = tostring(key)

  whichkey.register({ [key] = rhs }, {
    prefix = jump_leader,
    mode = "n",
  })
end

-- Add GrappleSelect keymap and center viewport
local function add_select_keymap(key, filename)
  local name = string.match(filename, "[^/]+$")
  register_key_map(key, CMD("GrappleSelect key=" .. key) .. " |zz", "Jump to [" .. name .. "]")
end

-- Remove GrappleSelect keymap
local function remove_select_keymap(key)
  register_key_map(key, "<Nop>", "")
end

-- Unset all select keymaps
local function unset_all_select_keymaps()
  local s = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

  for i = 1, #s do
    local key = s:sub(i, i)
    register_key_map(key, "<Nop>", "")
  end
end

-- Set keymaps for active tags
local function set_named_select_keymap()
  local settings = require "grapple.settings"
  local scope = require("grapple.state").ensure_loaded(settings.scope)
  local popup_items = require("grapple.tags").full_tags(scope)
  for _, item in pairs(popup_items) do
    local key = tostring(item.key)
    local filename = string.match(item.file_path, "[^/]+$")
    if #key == 1 then
      add_select_keymap(key, filename)
    end
  end
end

-- Update all Grapple select keymaps
local groupname = vim.api.nvim_create_augroup("grapple-update", {})
vim.api.nvim_create_autocmd({ "BufLeave" }, {
  group = groupname,
  callback = function()
    if vim.bo.filetype == "grapple" then
      vim.schedule(function()
        unset_all_select_keymaps()
        set_named_select_keymap()
      end)
    end
  end,
})

function M.init()
  local grapple = require "grapple"
  local whichkey = require "which-key"

  set_named_select_keymap()

  vim.keymap.set("n", "<leader>J", function()
    grapple.toggle()
    local key = grapple.key()
    if key == nil then
      Notify.info "Removed key"
      return
    end
    local buffer_name = vim.api.nvim_call_function("bufname", {})
    add_select_keymap(key, buffer_name)
    CMD "redrawtabline"
    Notify.info(string.format("Tagged with key [%s]", key))
  end, { noremap = true, silent = true })
  whichkey.register({
    ["="] = {
      function()
        grapple.tag()
        local key = grapple.key()
        local buffer_name = vim.api.nvim_call_function("bufname", {})
        add_select_keymap(key, buffer_name)
        Notify.info(string.format("Tagged [%s]", key))
      end,
      "Anonymous Tag",
    },
    ["+"] = {
      function()
        vim.ui.input("Tag name: ", function(input)
          local name = input
          if name == nil then
            return
          end
          grapple.tag({ key = name })
          if #name == 1 then
            local buffer_name = vim.api.nvim_call_function("bufname", {})
            add_select_keymap(name, buffer_name)
          end
          Notify.info(string.format("Tagged [%s]", name))
        end)
      end,
      "Named Tag",
    },
    ["-"] = {
      function()
        local key = grapple.key()
        remove_select_keymap(key)
        grapple.untag()
        CMD "redrawtabline"
      end,
      "Untag",
    },
    [backslash] = {
      function()
        grapple.popup_tags()
        CMD "redrawtabline"
      end,
      "View tags",
    },
    ["]"] = {
      grapple.cycle_forward,
      "Cycle forward",
    },
    ["["] = {
      grapple.cycle_backward,
      "Cycle back",
    },
  }, {
    prefix = backslash,
    mode = "n",
  })
end

return M
