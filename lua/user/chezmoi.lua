local chezmoi = vim.api.nvim_create_augroup("chezmoi", {})

vim.api.nvim_create_autocmd({ "VimLeave" }, {
  desc = "Prevent edits to files managed by chezmoi",
  pattern = {
    "*.sh",
    "*.lua",
    "*.fish",
    "*.conf",
    "*.yml",
    "*.ini",
    "*.toml",
    ".gitconfig",
    "*.md",
    "*/spacebar/*",
  },
  group = chezmoi,
  callback = function()
    local filepath = vim.fn.expand "%:p"
    local handle = io.popen(string.format("chezmoi source-path %s", filepath))
    if handle == nil then
      return
    end
    local output = handle:read "*all"

    if output ~= "" then
      local status = os.execute "chezmoi --version"
      if status then
        Notify.warn "This file is managed by chezmoi"
      end
    end
    handle:close()
  end,
})

-- local handle = io.popen "chezmoi source-path"
-- if handle == nil then
-- 	return
-- end
--
-- local sourcepath = handle:read "*all"

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  desc = "Apply changes to chezmoi source files to their destination",
  pattern = "*/chezmoi/dot_config/**",
  group = chezmoi,
  callback = function()
    local filepath = vim.fn.expand "%:p"

    local update_source_path_cmd = string.format("chezmoi apply --force --source-path %s >/dev/null 2>&1", filepath)
    local status = os.execute(update_source_path_cmd)

    if status ~= 0 then
      -- Check if this file has a destination, if it is then notify, otherwise we don't care
      local is_in_source_state = os.execute(string.format("chezmoi source-path %s >/dev/null 2>&1", filepath))
      if is_in_source_state == 0 then
        Notify.error(string.format("Update to %s destination failed", filepath))
      end
    end
  end,
})
