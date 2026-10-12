# Phase 3: Search & Syntax Intelligence

## Status

Complete. Treesitter parser installation, native highlighting and indentation, Telescope lazy loading,
and native FZF sorting were verified headlessly.

## Treesitter

The configuration uses the current `nvim-treesitter` main branch, whose setup differs from the legacy
plugin configuration. The plugin is eager because the current branch does not support lazy loading.
Parsers are installed with `require("nvim-treesitter").install()` and the `tree-sitter` CLI is checked
before installation so a missing external dependency cannot break startup.

Configured parsers:

- Markdown and Markdown inline
- Fish
- Lua
- HTML and CSS
- JavaScript, TypeScript, and TSX
- Go
- Ruby
- SQL
- Hurl

Neovim's native `vim.treesitter.start()` provides highlighting. A `FileType` autocmd starts
highlighting when a parser is available and enables the nvim-treesitter indentation expression. YAML
is intentionally excluded from Treesitter indentation because its native indentation is more reliable
for this configuration.

Verified:

- `tree-sitter` 0.27.1 is available.
- All configured parser shared libraries are installed under the nvim-2027 data directory.
- Lua and Markdown parsers load successfully.
- YAML keeps its native indentation expression.
- Startup succeeds when optional executables are hidden by a restricted PATH.

## Telescope

Telescope is lazy-loaded by its command and actual key declarations. The configured mappings cover
file search, live grep, current-buffer fuzzy search, recent files, resume, diagnostics, marks, and
colorscheme selection. The existing action, layout, picker, and multi-selection settings were ported.

`telescope-fzf-native.nvim` is built with `make`, loaded as the fzf extension, and configured for smart
case sorting.

Verified:

- Telescope is not loaded during initial startup.
- Telescope loads when a picker is invoked.
- The fzf extension loads successfully after invocation.
- The native keymaps remain independent of which-key.nvim.

## Removed functionality

The old custom Telescope knowledge-base extension was not ported because it is unused. The WIP
configuration does not load or reference it.

## Validation

```text
== headless startup ==
ok:   headless startup

== startup messages ==
ok:   no startup errors

== missing dependencies ==
ok:   startup with restricted PATH

== Lua syntax ==
ok:   luajit syntax check

== formatting ==
ok:   stylua format check

== LuaLS diagnostics ==
ok:   lua-language-server diagnostics

All executed checks passed.
```
