local api = vim.api
local fn = vim.fn
local buffer = require "user.buffer"

--- @class Module
--- @field prompt_buf Buffer
--- @field output_buf Buffer
local M = {}

local conversation_started = false

function M.setup_interface()
  api.nvim_command "tabnew"
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.wrap = true
  vim.wo.linebreak = true

  local prompt_buf = buffer.create_buffer("[AI Prompt]", { listed = false, scratch = true })
  M.prompt_buffer = prompt_buf

  api.nvim_buf_set_name(prompt_buf:id(), "[AI Prompt]")

  api.nvim_win_set_buf(0, prompt_buf:id())

  api.nvim_command "vsplit"

  local output_buf = buffer.create_buffer("[AI Ouput]", { listed = false, scratch = true }, { filetype = "markdown" })

  M.output_buf = output_buf -- Store in tab variable

  -- Associate output buffer with the new window (which is now current)
  api.nvim_win_set_buf(0, output_buf:id())

  -- 5. Move focus back to the prompt window (left)
  api.nvim_command "wincmd h" -- Move cursor left

  -- 6. Set up a buffer-local keymap in the prompt buffer to send the prompt
  --    Using <Cmd> prevents mode changes and command line clutter
  prompt_buf:set_keymap("n", "<CR>", "", {
    noremap = true,
    silent = true,
    desc = "Send prompt to AI",
    callback = function()
      output_buf:set_is_modifiable(true)
      output_buf:set_lines({ "Thinking about that..." })

      M.send_prompt()
    end,
  })

  prompt_buf:set_keymap("n", Del, "", {
    noremap = true,
    silent = true,
    desc = "Clear prompt",
    callback = function()
      prompt_buf:clear()
      vim.cmd "startinsert"
    end,
  })
end

function M.send_prompt()
  local prompt_buf = M.prompt_buffer
  local output_buf = M.output_buf

  if not prompt_buf or not output_buf or not prompt_buf:is_valid() or not output_buf:is_valid() then
    Notify.error "Error: AI buffers not found in this tab."
    return
  end

  -- Get all lines from the prompt buffer
  local prompt_lines = api.nvim_buf_get_lines(prompt_buf:id(), 0, -1, false)
  table.insert(prompt_lines, "Make sure all lines wrap after 80 characters.")
  local prompt_text = table.concat(prompt_lines, "\n")

  if prompt_text == "" then
    Notify.error "Error: Prompt buffer is empty."
    return
  end

  vim.cmd "redraw"

  local cmd = "mods"
  if conversation_started then
    cmd = cmd .. " --continue-last"
  end
  local output = fn.system(cmd, prompt_text)
  local exit_code = vim.v.shell_error

  output_buf:clear()

  if exit_code ~= 0 then
    Notify.error("Error running mods (exit code " .. exit_code .. "): " .. output)
    output_buf:set_lines({
      "Error running mods CLI:",
      "Exit Code: " .. exit_code,
      "Output:",
      output,
    })
  else
    local output_lines = vim.split(output, "\n", { plain = true })

    if #output_lines > 0 and output_lines[#output_lines] == "" then
      table.remove(output_lines)
    end

    output_buf:set_lines(output_lines)
  end

  output_buf:set_is_modifiable(false)
end

function M.setup()
  api.nvim_create_user_command("OpenAiTab", M.setup_interface, { nargs = 0, desc = "Open AI Prompt/Output Interface" })
end

local wk = require "which-key"

wk.add({
  { LeaderKey "a", group = "AI Actions" },
  {
    LeaderKey "ao",
    function()
      M.setup_interface()
      conversation_started = true
    end,
    desc = "Open AI Tab",
  },
})

return M
