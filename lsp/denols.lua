return {
  cmd = { "deno", "lsp" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_dir = function(buffer, on_dir)
    local root = vim.fs.root(buffer, { "deno.json", "deno.jsonc" })
    if root then
      on_dir(root)
    end
  end,
}
