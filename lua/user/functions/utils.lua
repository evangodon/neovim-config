local U = {}

-- Reload config
U.reloadConfig = function()
  -- Remove all autocmds
  vim.cmd [[autocmd!]]
  -- Certain packages complain when setup is called twice
  package.loaded["nvim-tree"] = nil
  package.loaded["which-key"] = nil

  -- My config
  for name, _ in pairs(package.loaded) do
    if name:match "^user." or name:match "^plugins." then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
  Notify.info "Reloaded config"
end

-- Set leader keymappings
U.register_key_map = function(keys, opts)
  local defaults = vim.tbl_extend("keep", { prefix = "<leader>" }, opts or {})
  local wk = require "which-key"
  wk.register(keys, defaults)
end

function U.toggle_option(option)
  return function()
    local current_state = vim.opt[option]:get()
    vim.opt[option] = not current_state
    Notify.info((current_state and "Disabled" or "Enabled") .. string.format(" option %s", option))
  end
end

function U.get_color(group, attr)
  local fn = vim.fn
  return fn.synIDattr(fn.synIDtrans(fn.hlID(group)), attr)
end

function U.truncate_string(str, max_length)
  if #str <= max_length then
    return str
  end
  return str.sub(str, 1, max_length) .. "…"
end

local superscript = {
  ["0"] = "⁰",
  ["1"] = "¹",
  ["2"] = "²",
  ["3"] = "³",
  ["4"] = "⁴",
  ["5"] = "⁵",
  ["6"] = "⁶",
  ["7"] = "⁷",
  ["8"] = "⁸",
  ["9"] = "⁹",
  ["a"] = "ᵃ",
  ["b"] = "ᵇ",
  ["c"] = "ᶜ",
  ["d"] = "ᵈ",
  ["e"] = "ᵉ",
  ["f"] = "ᶠ",
  ["g"] = "ᵍ",
  ["h"] = "ʰ",
  ["i"] = "ⁱ",
  ["j"] = "ʲ",
  ["k"] = "ᵏ",
  ["l"] = "ˡ",
  ["m"] = "ᵐ",
  ["n"] = "ⁿ",
  ["o"] = "ᵒ",
  ["p"] = "ᵖ",
  ["q"] = "q",
  ["r"] = "ʳ",
  ["s"] = "ˢ",
  ["t"] = "ᵗ",
  ["u"] = "ᵘ",
  ["v"] = "ᵛ",
  ["w"] = "ʷ",
  ["x"] = "ˣ",
  ["y"] = "ʸ",
  ["z"] = "ᶻ",
  ["A"] = "ᴬ",
  ["B"] = "ᴮ",
  ["C"] = "ᶜ",
  ["D"] = "ᴰ",
  ["E"] = "ᴱ",
  ["F"] = "ᶠ",
  ["G"] = "ᴳ",
  ["H"] = "ᴴ",
  ["I"] = "ᴵ",
  ["J"] = "ᴶ",
  ["K"] = "ᴷ",
  ["L"] = "ᴸ",
  ["M"] = "ᴹ",
  ["N"] = "ᴺ",
  ["O"] = "ᴼ",
  ["P"] = "ᴾ",
  ["Q"] = "Q",
  ["R"] = "ᴿ",
  ["S"] = "ˢ",
  ["T"] = "ᵀ",
  ["U"] = "ᵁ",
  ["V"] = "ⱽ",
  ["W"] = "ᵂ",
  ["X"] = "ˣ",
  ["Y"] = "ʸ",
  ["Z"] = "ᶻ",
}

function U.get_superscript(char)
  local str_char = tostring(char)
  if #str_char > 1 then
    return ""
  end
  local sup = superscript[str_char]
  return sup and sup or char
end

-- TODO: handle buffer with unsaved change
function U.close_all_buffers_but_current()
  local cur_bufid = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()

  for _, buf_id in ipairs(buffers) do
    if vim.api.nvim_buf_is_valid(buf_id) and vim.bo[buf_id].buflisted and buf_id ~= cur_bufid then
      vim.api.nvim_buf_delete(buf_id, {})
    end
  end
end

---@param mode string | table
---@param key string
---@param action string | function
---@param desc string?
function U.keymap(mode, key, action, desc)
  local keymap = vim.keymap.set
  local opts = { noremap = true, silent = true, desc = desc or "" }

  keymap(mode, key, action, opts)
end

---@param input string
function U.all_nums_to_superscript(input)
  return (input:gsub("%d", function(digit)
    return superscript[digit] or digit
  end))
end

-- Function to strip ANSI escape codes
---@param lines string[]
function U.strip_ansi_codes(lines)
  local stripped = {}
  for i, line in ipairs(lines) do
    local cleaned_line = string.gsub(line, "\x1b%[[0-9;]*m", "")

    table.insert(stripped, i, cleaned_line)
  end
  return stripped
end

return U
