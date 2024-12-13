-- Global functions

-- Global notification function
Notify = {}
function Notify.info(msg)
  Snacks.notify.info(msg)
end

function Notify.warn(msg)
  Snacks.notify.warn(msg)
end

function Notify.error(msg)
  Snacks.notify.error(msg)
end

-- Pretty print lua code with Notify
function P(value)
  Notify.info(vim.inspect(value))
end

function Get_loaded_buffers()
  local all_buffers = vim.api.nvim_list_bufs()
  local loaded_buffers = vim.tbl_filter(function(buf)
    if not buf or buf < 1 then
      return false
    end
    return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
  end, all_buffers)
  return loaded_buffers
end

-- Format string for ex command
function CMD(command)
  return string.format(":%s<cr>", command)
end

-- Format string for ex command
function LeaderKey(key)
  return string.format("<leader>%s", key)
end
