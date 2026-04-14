---
name: fetching-neovim-docs
description: Fetches current official Neovim documentation sections and uses them as targeted context during config review or implementation work. Use when reviewing this Neovim config, validating Neovim APIs or options, or when the user asks for current Neovim documentation.
---

# Fetching Neovim Docs

## Quick start

Use the official Neovim docs site as the primary source:

- `https://neovim.io/doc/user/`
- `https://neovim.io/doc/user/lua-guide/`
- `https://neovim.io/doc/user/lua/`
- `https://neovim.io/doc/user/api/`
- `https://neovim.io/doc/user/lsp/`
- `https://neovim.io/doc/user/options/`

Use raw docs from the Neovim repo when plain text is better:

- `https://raw.githubusercontent.com/neovim/neovim/master/runtime/doc/lua-guide.txt`
- `https://raw.githubusercontent.com/neovim/neovim/master/runtime/doc/lua.txt`
- `https://raw.githubusercontent.com/neovim/neovim/master/runtime/doc/api.txt`
- `https://raw.githubusercontent.com/neovim/neovim/master/runtime/doc/lsp.txt`
- `https://raw.githubusercontent.com/neovim/neovim/master/runtime/doc/options.txt`
- `https://raw.githubusercontent.com/neovim/neovim/master/runtime/doc/index.txt`

## Workflow

1. Read the user’s config files first.
2. Identify the Neovim topics actually used.
3. Fetch only the relevant official docs pages.
4. Summarize the specific rules or APIs that apply.
5. Keep the fetched docs out of long-term context unless they are still actively needed.

## Topic mapping

Match config patterns to documentation:

- `vim.api.nvim_*` calls → fetch `api/` or `api.txt`
- `vim.lsp.*` or LSP setup → fetch `lsp/` and `api/`
- `vim.opt`, `vim.o`, `vim.bo`, `vim.wo` → fetch `options/`
- Lua module patterns, keymaps, autocmds, user commands → fetch `lua-guide/` and `lua/`
- Behavior differences from Vim → fetch `vim_diff/`

## Rules

### Prefer official sources

Always prefer `neovim.io/doc/user/` or the `neovim/neovim` raw docs over third-party blog posts.

### Fetch on demand

Do not dump all Neovim docs into agent context. Fetch only the sections needed for the code being reviewed or changed.

### Prefer section-level context

When possible, fetch a single relevant page instead of the full documentation corpus.

Good examples:

- reviewing `vim.api.nvim_create_autocmd` usage → fetch `https://neovim.io/doc/user/api/`
- reviewing `vim.lsp.config` usage → fetch `https://neovim.io/doc/user/lsp/`
- reviewing editor options → fetch `https://neovim.io/doc/user/options/`

### Use raw text for compact quoting

Use raw GitHub `.txt` docs when you need compact excerpts or direct help-tag style text.

### Keep local copies secondary

If this repo contains local notes or copied Neovim docs, treat them as secondary. Prefer the latest official docs for current guidance.

## Review pattern for this repo

When reviewing this config:

1. Start with the Lua files in `lua/`, `init.lua`, `ftdetect/`, and `vscode.lua`.
2. Ignore large nonessential files unless the task needs them.
3. Fetch only the official Neovim docs sections touched by the config under review.
4. Base suggestions on current Neovim behavior, not outdated plugin-era patterns.

## What to avoid

- Do not fetch the entire Neovim documentation set by default.
- Do not rely on unofficial tutorials when official docs cover the topic.
- Do not use stale local copies of docs as the primary source.
- Do not spend context on unrelated help pages.
