local api = vim.api
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
  prompt_buf:set_keymap("n", Tab, "<Nop>")
  M.prompt_buffer = prompt_buf
  vim.cmd "startinsert"

  api.nvim_win_set_buf(0, prompt_buf:id())

  api.nvim_command "vsplit"

  local output_buf = buffer.create_buffer("[AI Ouput]", { listed = false, scratch = true }, { filetype = "markdown" })
  M.output_buf = output_buf
  output_buf:set_keymap("n", Del, "<Nop>")
  output_buf:set_keymap("n", Tab, "<Nop>")
  output_buf:set_is_modifiable(false)

  api.nvim_win_set_buf(0, output_buf:id())

  api.nvim_command "wincmd h" -- Move cursor left

  local unloaded_buffers = vim.tbl_filter(function(bufnr)
    return vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_name(bufnr) == ""
  end, vim.api.nvim_list_bufs())

  for _, bufnr in ipairs(unloaded_buffers) do
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end

  prompt_buf:set_keymap("n", "<CR>", "", {
    noremap = true,
    silent = true,
    desc = "Send prompt to AI",
    callback = function()
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

  local prompt_text = api.nvim_buf_get_lines(prompt_buf:id(), 0, -1, false)
  local full_prompt = table.concat(prompt_text, "\n")
  local trimmed_prompt = string.match(full_prompt, "^%s*(.-)%s*$")

  if trimmed_prompt == nil or trimmed_prompt == "" then
    Notify.error "Error: Prompt buffer is empty or contains only whitespace."
    return
  end

  vim.cmd "redraw"

  output_buf:set_is_modifiable(true)
  output_buf:clear()

  local cmd = { "mods", "--quiet", "--raw", "--no-cache" }
  if conversation_started then
    table.insert(cmd, "--continue-last")
  end

  output_buf:clear()
  local job_id = vim.fn.jobstart(cmd, {
    stdout_buffered = false,
    stderr_buffered = false,
    pty = false,
    stdin = "pipe",

    on_stdout = function(_, data, _)
      if not data or #data == 0 then
        return
      end

      local lines_to_insert = {}
      local has_real_content = false
      for _, line in ipairs(data) do
        local processed_line = string.gsub(line, "([%.?!])%s%s+", "%1 ")
        table.insert(lines_to_insert, processed_line)
        if processed_line ~= "" then
          has_real_content = true
        end
      end

      if not has_real_content and #lines_to_insert > 0 then
        return
      end

      if #lines_to_insert > 0 then
        local buf_id = output_buf:id()
        vim.schedule(function()
          output_buf:set_is_modifiable(true)
          if not vim.api.nvim_buf_is_valid(buf_id) then
            return
          end

          local end_row = vim.api.nvim_buf_line_count(buf_id) - 1
          if end_row < 0 then
            end_row = 0
          end

          local last_line_content = vim.api.nvim_buf_get_lines(buf_id, end_row, end_row + 1, false)[1] or ""
          local end_col = #last_line_content

          vim.api.nvim_buf_set_text(buf_id, end_row, end_col, end_row, end_col, lines_to_insert)
        end)
      end
    end,

    on_stderr = function(_, data, _)
      if data and #data > 0 then
        local stderr_lines = {}
        for _, line in ipairs(data) do
          if line and line ~= "" then
            table.insert(stderr_lines, "[stderr] " .. line)
          end
        end
        if #stderr_lines > 0 then
          local buf_id = output_buf:id()
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(buf_id) then
              vim.api.nvim_buf_set_lines(buf_id, -1, -1, false, stderr_lines)
            end
          end)
        end
      end
    end,

    on_exit = function()
      output_buf:set_is_modifiable(false)
    end,
  })

  if job_id <= 0 then
    Notify.error("Error: Failed to start job. Code: " .. job_id)
  else
    vim.fn.chansend(job_id, prompt_text)
    vim.fn.chanclose(job_id, "stdin")
  end
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
