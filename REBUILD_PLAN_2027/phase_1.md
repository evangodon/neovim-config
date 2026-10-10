# Phase 1: Core Infrastructure

## Status

Complete. The configuration starts successfully in headless Neovim 0.13 mode and all automated
checks pass.

## Completed

- Created the fresh `nvim-2027` configuration worktree and kept the stable configuration in
  `~/.config/nvim`.
- Created the planned core module structure:
  - `init.lua`
  - `lua/config/options.lua`
  - `lua/config/keymaps.lua`
  - `lua/config/lazy.lua`
  - `lua/config/lsp.lua`
  - `lua/config/autocmds.lua`
- Created feature-grouped plugin module placeholders under `lua/plugins/`.
- Set both `mapleader` and `maplocalleader` to `<Space>` at the top of `lua/config/keymaps.lua`,
  before any mapping is defined.
- Migrated the old editor options into `lua/config/options.lua`, including clipboard support,
  persistent undo, relative numbering, two-space indentation, search behavior, split behavior,
  signs, wrapping, scrolling, and display settings. Original option comments were preserved.
- Migrated dependency-free keymaps into `lua/config/keymaps.lua`, including save, window movement,
  resizing, indentation, buffer navigation, text movement, displayed-line navigation, search and
  editing behavior, terminal escape, and recording prevention. Original comments were preserved.
- Migrated dependency-free autocommands into `lua/config/autocmds.lua`:
  - Yank highlighting
  - Restoring the last cursor position on buffer read
  - Clearing search highlighting when entering Insert or Cmdline mode
  - Closing common UI filetypes with `q`
  - Closing the quickfix window after selecting an entry
  - Treating `.rasi` files as CSS
  - Deriving the filetype from Chezmoi `.tmpl` filenames
- Migrated the `lazy.nvim` bootstrap into `lua/config/lazy.lua` and updated it to the current
  recommended structured setup using `spec = { { import = "plugins" } }`.
- Added empty plugin modules as `return {}` so Lazy can load the feature groups before plugins are
  added.
- Added `stylua.toml` matching the stable configuration's formatting rules.
- Replaced `which-key.nvim` with a dependency-free native leader-key popup in
  `lua/util/keymap_popup.lua`, bound to `<leader>?`.
- Migrated the dependency-free leader mappings: `<leader>q` (force quit), `<leader>c` (close
  window), `<leader>Tc` (toggle `cursorcolumn`), and `<leader>Tr` (toggle `relativenumber`). The
  option toggles use a small annotated local helper instead of the old `user.functions.utils`
  module.

## Native leader-key popup

`lua/util/keymap_popup.lua` displays every global and buffer-local mapping that begins with the
leader key. It is a self-contained helper rather than configuration, so it lives under `lua/util/`.
It uses only Neovim APIs:

- Collects mappings through `nvim_get_keymap()` and `nvim_buf_get_keymap()`.
- Derives modes from each mapping's own `mode` field, so overlapping visual modes are not
  duplicated.
- Merges entries with the same left-hand side and combines their modes.
- Replaces the leading leader key with `<Leader>` for readability.
- Falls back to the mapping's right-hand side when no description exists.
- Enumerates mappings at invocation time, so mappings added later by plugins are included.
- Reports `No leader mappings are defined` instead of opening an empty window.
- Caps the window height and keeps every line in the buffer, so long lists remain scrollable.

Close the popup with `q` or `<Esc>`. Executing a mapping from the popup is not implemented; the
popup is read-only for now.

## Validation

Run the bundled script from the configuration root:

```sh
.crush/skills/validating-neovim-commands/scripts/validate.sh
```

Current result:

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
skip: lua-language-server not installed

All executed checks passed.
```

The LuaLS check is skipped because `lua-language-server` is not installed on this machine. It is
not a passing result. Install the language server before closing a phase that adds or changes
annotated functions.

## Deferred from the old configuration

Mappings that depend on plugins or custom modules remain deferred until their feature is migrated.
These include Telescope, Alpha, NvimTree, Comment.nvim, LSP, custom utility functions, and custom
commands.

Other items intentionally not carried over in this phase:

- `which-key.nvim` is removed in favor of the native popup.
- The Svelte and Astro `prettier` autocommand is deferred to the formatting phase, because it
  shells out to an external formatter.
- The `CloseBuffer` command and its `<C-w>` mapping are deferred, because the single-buffer branch
  invokes the Alpha dashboard.
- Kitty font resizing and other terminal-specific behavior remains deferred.

## Known gaps

- `lua/config/lsp.lua` is still an empty placeholder; native LSP setup belongs to Phase 4.
- Executing a mapping directly from the leader popup is not implemented.
- The old configuration's `<C-w>` buffer-closing behavior needs a decision once a file explorer and
  dashboard exist.
