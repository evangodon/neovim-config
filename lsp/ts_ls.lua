return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_dir = function(buffer, on_dir)
    local deno_root = vim.fs.root(buffer, { "deno.json", "deno.jsonc" })
    if deno_root then
      return
    end

    local bun_root = vim.fs.root(buffer, { "tsconfig.json", "bunfig.toml", "bun.lock", "bun.lockb" })
    if bun_root then
      return
    end

    local root = vim.fs.root(buffer, { "package.json", "tsconfig.json", "jsconfig.json", ".git" })
    if root then
      on_dir(root)
    end
  end,
}
