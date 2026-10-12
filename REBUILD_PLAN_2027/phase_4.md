# Phase 4: Native LSP Configuration

## Status

Implemented. Native LSP setup and the available server definitions are active; missing host executables are skipped safely.

## Goal

Configure language servers with Neovim's built-in client while keeping startup safe when external
servers are absent. Server installation and version management remain host-managed concerns, not
Neovim configuration responsibilities.

## Constraints

- Use `vim.lsp.config()` and `vim.lsp.enable()` from Neovim 0.13.
- Do not use `nvim-lspconfig`, `lsp-zero`, `mason.nvim`, or `mason-lspconfig.nvim`.
- Keep shared LSP setup, diagnostics, executable gating, and `LspAttach` behavior in
  `lua/config/lsp.lua`.
- Define individual server configurations in the native `lsp/` directory at the config root, with
  one file per server such as `lsp/lua_ls.lua` and `lsp/gopls.lua`. Neovim discovers these files
  from `runtimepath` when resolving `vim.lsp.config()` and `vim.lsp.enable()`.
- Keep completion capability and completion UI work in Phase 5.
- Preserve stable configuration isolation.

## Initial server scope

| Config | Executable | Filetypes | Root and safety notes |
|---|---|---|---|
| `lua_ls` | `lua-language-server` | Lua | Use LuaJIT and Neovim runtime settings; prefer `.luarc.json` and `.git`. |
| `ts_ls` | `typescript-language-server` | JavaScript, TypeScript, JSX, TSX | Use package and TypeScript project markers. |
| `denols` | `deno` | JavaScript, TypeScript, JSX, TSX | Enable only for Deno projects and avoid overlap with `ts_ls`. |
| `eslint` | `vscode-eslint-language-server` | JavaScript, TypeScript, JSX, TSX | Require an ESLint project marker. |
| `gopls` | `gopls` | Go | Use `go.mod` and `.git` roots. |
| `jsonls` | `vscode-json-language-server` | JSON, JSONC | Enable when installed. |
| `ruby_lsp` | `ruby-lsp` | Ruby, ERB | Use `Gemfile` and `.git` roots. |

The implementation may narrow this list if a server cannot be safely identified or isolated without
plugin support. Python is deferred until a concrete server and project requirement exist. ZK remains
part of later notes/knowledge-base work.

## Implementation checklist

- Define server configurations with explicit commands, filetypes, settings, and root markers.
- Check `vim.fn.executable()` before defining and enabling each server.
- Skip unavailable servers without startup errors and record the decision through the logging helper.
- Add one `LspAttach` autocmd with buffer-local, capability-aware mappings.
- Cover definition, declaration, implementation, references, type definition, hover, signature help,
  rename, code actions, diagnostics, and formatting when the attached client supports them.
- Keep diagnostics configuration independent of UI plugins.
- Account for Neovim's built-in global LSP mappings (`gra`, `gri`, `grn`, `grr`, `grt`, `grx`, `gO`,
  and Insert-mode `<C-s>`), which are created at startup in current nightly. Override or retain them
  deliberately rather than assuming they are absent before `LspAttach`.
- Make setup safe to load once from `init.lua` without starting servers at require time.

## Verification checklist

- Headless startup succeeds with language-server executables hidden.
- Available servers attach only to their intended filetypes and project roots.
- Missing executables are skipped and do not reach `vim.lsp.enable()`.
- `LspAttach` creates buffer-local mappings only after a client attaches.
- LSP mappings are absent from unrelated buffers.
- Diagnostics, hover, definition, references, rename, code actions, and formatting paths do not throw
  when the server lacks the corresponding capability.
- Standard formatting, syntax, startup, restricted-PATH, and LuaLS validation passes.

## Deferred

- Completion capabilities and completion UI belong to Phase 5.
- Automatic server installation belongs outside the Neovim configuration.
- ZK's specialized LSP integration belongs to a later notes/knowledge-base phase.
