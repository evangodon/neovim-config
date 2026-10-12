That makes complete sense. If you are feeding this into an agent, providing high-level objectives, constraints, and architecture rules is much better than hardcoding specific plugin specs. It lets the agent do the heavy lifting of writing the Lua code while adhering to your exact requirements.

Here is a revised, high-level blueprint written as a requirements document. You can copy this directly for your agent.

---

# Neovim Configuration Requirements Document

## Objective

Rebuild a Neovim configuration from scratch targeting **Neovim v0.11 - v0.13+**. The configuration must be modular, highly portable, and leverage native Neovim features (like native LSP) wherever possible to reduce plugin bloat.

## Architecture & Constraints

1. **Plugin Manager:** Use `lazy.nvim`. All plugins must be lazy-loaded where appropriate and defined in individual files inside a `lua/plugins/` directory.
2. **Directory Structure:**
* `init.lua` (Entry point)
* `lua/config/options.lua` (Vim options)
* `lua/config/keymaps.lua` (Global keymaps)
* `lua/config/lazy.lua` (Plugin manager bootstrap)
* `lua/config/lsp.lua` (Native LSP setup)
* `lua/config/autocmds.lua` (Global autocommands)
* `lua/util/*.lua` (Self-contained helper modules)
* `lua/plugins/*.lua` (Feature-grouped plugin specs)

Plugin files should group related functionality rather than requiring one file per plugin. For
example, `formatting.lua` may contain multiple formatting-related plugins, such as a formatter
orchestrator, formatter installer, and closely related dependencies. Keep a plugin in its own file
when it has substantial configuration, distinct lifecycle behavior, or needs independent migration
tracking.

3. **Type safety:** Use Lua Language Server annotations (EmmyLua/LuaLS comment annotations) for all
functions and methods. Type parameters, return values, fields, callback signatures, and relevant
local variables so LuaLS can detect incorrect usage. Avoid untyped functions except when the type
cannot be represented accurately, and document those exceptions with the narrowest practical type.

4. **Robustness:** The configuration must not crash or throw errors if a dependency (like an LSP binary, ripgrep, or a compiler) is missing from the host system.

5. **Keymap discovery:** Remove `which-key.nvim`; it is rarely used in the current configuration. Use descriptive native keymap metadata and investigate a small, custom popup that displays all mappings beginning with the configured leader key. The popup must use Neovim APIs, remain dependency-free, handle mappings added later, and degrade gracefully when no leader mappings exist.

6. **Rollback and isolation:** Preserve the stable configuration in `~/.config/nvim` and keep all rebuild work isolated in `~/.config/nvim-2027`. The WIP configuration must remain independently launchable and usable throughout the migration. Do not make changes to the stable configuration as part of the rebuild unless explicitly requested.

7. **Portability:** Avoid hardcoded user paths, host-specific assumptions, and terminal-specific behavior. Use environment variables, Neovim path functions, executable checks, and feature detection where appropriate. Kitty-only or machine-specific integrations must degrade gracefully when unavailable.

8. **Plugin boundaries:** Group related plugin specifications by feature, such as multiple formatting plugins in `formatting.lua`. Keep a plugin in its own file when it has substantial configuration, distinct lifecycle behavior, or needs independent migration tracking. The grouping is organizational and must not prevent lazy-loading plugins independently.

---

All Lua code should use LuaLS annotations in comments above functions and methods, for example:

```lua
---@param buffer number
---@return boolean
local function is_valid_buffer(buffer)
  return vim.api.nvim_buf_is_valid(buffer)
end
```

## Phase 1: Core Infrastructure

**Goal:** Establish the foundation without loading any external plugins.

* **Init:** Set the global and local mapleader to `Space` before anything else loads. Require the core config files.
* **Options (`options.lua`):** Configure standard quality-of-life settings: relative line numbers, 2-space indentation, smart case search, persistent undo, and sync with the system clipboard.
* **Keymaps (`keymaps.lua`):** Bind `<Esc>` to clear search highlights. Create keybindings for easy window split navigation (e.g., `Ctrl` + `h/j/k/l`).
* **Bootstrap (`lazy.lua`):** Write the standard bootstrap script to clone `lazy.nvim` if it isn't installed, and configure it to import the `lua/plugins/` directory.

## Phase 1B: Utility Layer & Module Port

**Goal:** Port the existing custom modules into the new structure with explicit dependencies and no
implicit globals. This phase is placed directly after Phase 1 and before the plugin phases, because
several plugins migrated in later phases consume these utilities. Phases 2 through 7 keep their
existing numbers.

### Import rules

The old configuration relied on implicit global functions and load order. The rebuilt modules must
not repeat that:

* **No implicit globals.** Every module declares its dependencies with `require`. Nothing relies on
  a previously loaded file having defined a global.
* **No key-notation helpers.** Write literal `<C-s>` and `<leader>q` strings instead of `Ctrl "s"`
  or `LeaderKey "q"`, so mappings stay greppable and type-checkable.
* **No `Cmd()` wrapper.** Use `<cmd>...<CR>` strings and let Neovim report failures, instead of
  wrapping commands in closures that swallow errors.
* **No side effects on `require`.** A module must not create globals, autocommands, or user
  commands merely by being loaded. Explicit `setup()` calls own those.
* **Notifications are centralized.** `util/notify.lua` prefers `Snacks.notify` when the snacks
  plugin is loaded, and falls back to `vim.notify` otherwise. No other module touches a notifier
  directly, so nothing else inherits a plugin dependency.

### Target layout

```text
lua/util/
├── notify.lua      -- info/warn/error/debug, snacks-backed with vim.notify fallback
├── buffer.lua      -- listed buffers, close all but current
├── string.lua      -- superscript conversion and truncation
├── colors.lua      -- highlight group color lookup
├── icons.lua       -- shared icon definitions
├── floating_window.lua -- floating window runner for CLI output
└── keymap_popup.lua -- native leader-key popup (completed in Phase 1)
```

Feature modules that are our own code, rather than plugins or generic helpers, live in
`lua/features/`. Each one exposes an explicit `setup()` call and has no side effects on `require`.

### Module disposition

| Old module | Depends on | Disposition |
|---|---|---|
| `functions/globals.lua` | Snacks global | Replace with `util/notify.lua` and `util/buffer.lua` |
| `functions/utils.lua` | globals, implicitly | Split across `util/notify.lua`, `util/buffer.lua`, `util/string.lua`, `util/colors.lua` |
| `functions/init.lua` | globals, utils | Delete. It existed only to define globals as a require side effect |
| `functions/commands.lua` | kitty, external tools | Defer. Needs `presenterm` and `zk`; belongs with its feature |
| `functions/floating_window.lua` | none | Port as `util/floating_window.lua`. Dependency-free and reusable. It has no caller in the new tree yet, because its only caller was `work.lua`, but the behavior is used and the helper must be kept rather than deleted |
| `functions/kitty.lua` | Kitty | Defer. Terminal-specific and must degrade gracefully |
| `icons.lua` | none | Port as `util/icons.lua` alongside the statusline work |
| `buffer.lua` | none | Port as `util/buffer.lua` alongside the AI module |
| `scope_buffers.lua` | `Get_loaded_buffers` global | Port after `util/buffer.lua` exists |
| `chezmoi.lua` | `Notify` global | Port after `util/notify.lua` exists |
| `env.lua` | `Notify` global | Port with the knowledge-base picker |
| `marks.lua` | utils (`get_superscript`) | Port after `util/string.lua` exists |
| `colorscheme.lua` | utils, which-key | Phase 2, rewritten without which-key |
| `ai.lua` | buffer, which-key | Defer, rewritten without which-key |
| `work.lua` | which-key, utils, kitty, floating_window | Deleted. Not ported |

### Fixes to apply during the port

* `truncate_string` calls `str.sub(str, 1, max)`, but strings have no `.sub` field, so it errors.
  Use `str:sub(...)`.
* `Del` is defined as `<BS>`, which is Backspace rather than Delete. Drop the constant and write the
  key literally.
* `scope_buffers.lua` sets `buflisted = true` for every buffer when leaving a tab. That looks
  inverted for a feature meant to scope buffers to tabs; confirm the intended behavior before
  porting.
* `scope_buffers.lua` runs `M.setup()` at require time. Move that behind an explicit call.
* `marks.lua` registers its autocommands at require time. Move that behind an explicit call.
* `chezmoi.lua` builds shell command strings with `os.execute`, which interpolates the filename and
  breaks on paths containing spaces. Use `vim.system` with an argument list.
* `chezmoi.lua` calls `chezmoi source-path` with a source path when checking whether an apply
  failure matters. That lookup always fails, so apply failures are silently swallowed.
* `chezmoi.lua` warns on `VimLeave`, which is too late to act on, and only checks the current
  buffer. Route writes by direction instead: `re-add` when a managed destination is written, and
  `apply` when a source file is written. Templated destinations cannot be re-added and must be
  reported.
* `chezmoi.lua` runs `apply` synchronously, blocking the UI. Make it asynchronous and serialized.
* `floating_window.lua` sets `nomodifiable` on a terminal buffer, which prevents typing into the
  terminal it just opened.

### Dead code after deleting `work.lua`

* `strip_ansi_codes` loses its only caller and is dropped rather than ported.
* `floating_window.lua` loses its only caller, but the helper is deliberately kept because the
  behavior is still used. It needs a caller when the corresponding feature is ported.
* The `keymap` helper loses both callers (`grapple.lua`, `openingh.lua`) because later phases use
  literal `vim.keymap.set` calls.

### Restored by this phase

`<leader>B` (close all buffers but current) was skipped in Phase 1 because it needed
`user.functions.utils`. It can return once `util/buffer.lua` exists.

## Phase 2: Theme & Visual Base

**Goal:** Make the editor visually usable before configuring complex tools.

* **Colorscheme:** Pick a modern dark theme (e.g., TokyoNight, Catppuccin, or Rose Pine).
* **Constraint:** Ensure the theme plugin is loaded with high priority (`priority = 1000`) so it renders immediately on startup.

## Phase 3: Search & Syntax Intelligence

**Goal:** Enable code highlighting and project navigation.

* **Syntax:** Configure `nvim-treesitter` to ensure basic parsers (Lua, Markdown, Vimdoc) are installed and syntax highlighting/indentation is enabled.
* **Fuzzy Search:** Set up a fuzzy finder (e.g., Telescope or fzf-lua). Map keys for finding files, live grep, and listing active buffers.

## Phase 4: Native LSP Configuration

**Goal:** Configure language servers with Neovim's built-in client while keeping startup safe on machines
where some servers are not installed.

### Architecture

- Keep shared LSP setup, diagnostics, executable gating, and `LspAttach` behavior in
  `lua/config/lsp.lua`.
- Define individual server configurations in the native root-level `lsp/` directory, with one file
  per server. Neovim discovers these files from `runtimepath` when resolving `vim.lsp.config()` and
  `vim.lsp.enable()`.
- Use `vim.lsp.config()` and `vim.lsp.enable()` from Neovim 0.13.
- Do not add `nvim-lspconfig`, `lsp-zero`, `mason.nvim`, or `mason-lspconfig.nvim`.
- Do not make server installation part of the configuration. Language servers remain host-managed
  executables, documented separately from startup configuration.
- Keep completion capability wiring out of this phase unless it is required for the native client;
  completion behavior belongs to Phase 5.

### Initial server set

Port only the useful server definitions from the stable audit, with explicit filetypes and root
markers:

| Config | Executable | Filetypes | Initial disposition |
|---|---|---|---|
| `lua_ls` | `lua-language-server` | Lua | Enable when installed; use LuaJIT and Neovim runtime library settings. |
| `ts_ls` | `typescript-language-server` | JavaScript, TypeScript, JSX, TSX | Enable when installed. |
| `denols` | `deno` | JavaScript, TypeScript, JSX, TSX | Enable only for Deno projects, without competing with `ts_ls`. |
| `eslint` | `vscode-eslint-language-server` | JavaScript, TypeScript, JSX, TSX | Enable when installed and an ESLint project marker exists. |
| `gopls` | `gopls` | Go, Go module files | Enable when installed. |
| `jsonls` | `vscode-json-language-server` | JSON and JSONC | Enable when installed. |
| `ruby_lsp` | `ruby-lsp` | Ruby, ERB | Enable when installed. |

The exact server set may be narrowed during implementation if a server's executable, project-root
behavior, or overlap cannot be made reliable without a plugin. Python support is not included until
there is a concrete local server choice and project requirement.

### Configuration requirements

- Check `vim.fn.executable()` before defining and enabling each external server.
- Use project markers such as `.git`, `package.json`, `tsconfig.json`, `deno.json`, `deno.jsonc`,
  `eslint.config.js`, `go.mod`, `Gemfile`, `.luarc.json`, and `.git` to determine roots.
- Prevent `denols` and `ts_ls` from attaching to the same project.
- Configure diagnostics centrally with the existing icon and virtual-text policy, without coupling it
  to a UI plugin.
- Add one `LspAttach` autocmd that creates buffer-local, capability-aware mappings for definition,
  declaration, implementation, references, type definition, hover, signature help, rename, code
  actions, diagnostics, and formatting where supported.
- Account for Neovim's current built-in global LSP mappings (`gra`, `gri`, `grn`, `grr`, `grt`, `grx`,
  `gO`, and Insert-mode `<C-s>`), which are created at startup. Override or retain them deliberately
  rather than assuming they are absent before `LspAttach`.
- Preserve other Neovim LSP defaults unless there is a documented reason to override them.
- Make repeated configuration loads safe and avoid require-time server startup side effects beyond
  explicit setup from `init.lua`.
- Log missing servers at debug or info level rather than treating them as startup errors.

### Verification

- Start with no language-server executables available and confirm there are no startup errors.
- Start with each available server and verify the expected filetype, root, client name, and attach
  event in a temporary fixture project.
- Verify that missing executables are skipped without calling `vim.lsp.enable()` for them.
- Verify buffer-local mappings are created only after `LspAttach` and are removed with the buffer.
- Verify diagnostics, hover, definition, references, rename, code actions, and formatting mappings do
  not appear globally before a client attaches.
- Run the standard validation script, LuaLS, and headless LSP smoke tests.

### Deferred

- Completion engine capabilities and UI remain Phase 5.
- Server installation and version management remain outside the Neovim configuration.
- ZK's LSP integration remains with the later notes/knowledge-base work rather than becoming a
  generic language-server definition in this phase.

## Phase 5: Autocompletion & Snippets

**Goal:** Provide intelligent code completion.

* **Implementation:** Set up an autocomplete engine (e.g., `blink.cmp` or `nvim-cmp`).
* **Integration:** Ensure the completion engine correctly sources data from the native LSP client, buffer text, and snippets.

## Phase 6: UI Enhancements

**Goal:** Improve the editor's interface for daily use.

* **File Manager:** Configure a file explorer (e.g., `oil.nvim` or `neo-tree`) and map a key to toggle or open it.
* **Statusline:** Configure a statusline (e.g., `lualine.nvim`) to show mode, branch, file name, and diagnostics.

## Phase 7: Formatting & Polish (Optional)

**Goal:** Ensure code is automatically formatted to standard style guidelines.

* **Implementation:** Configure a formatting tool (e.g., `conform.nvim`) to format buffers on save, falling back to LSP formatting if a dedicated formatter (like `stylua` or `prettier`) isn't available.
