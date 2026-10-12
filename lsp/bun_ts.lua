return {
  cmd = { "bunx", "--bun", "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_dir = function(buffer, on_dir)
    local root = vim.fs.root(buffer, { "tsconfig.json", "bunfig.toml", "bun.lock", "bun.lockb" })
    if root then
      on_dir(root)
    end
  end,
}
