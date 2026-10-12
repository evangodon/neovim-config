# Current Configuration Audit

This inventory reflects the plugin specifications currently loaded from `lua/plugins/`, plus the
`lazy.nvim` bootstrap in `lua/user/lazy.lua`. It is an audit of the existing configuration, not a
recommendation for the rebuild.

## Summary

- **52 unique plugin repository specifications** are present under `lua/plugins/`.
- **41 are direct/top-level declarations** and **11 are dependency-only declarations**.
- `lazy.nvim` is the plugin manager and is bootstrapped separately, so it is listed below but is
  not included in the 52-plugin count.
- The global Lazy default is `lazy = true`; several plugins override this with eager loading.
- There are repeated declarations of some dependencies, but no duplicate direct plugin specs.
- `kyazdani42/nvim-web-devicons` and `nvim-tree/nvim-web-devicons` are different repositories
  providing overlapping icon functionality.

## Plugin inventory

| Plugin | Status | Category | Role | Declaration and configuration summary |
|---|---|---|---|---|
| `neovim/nvim-lspconfig` | open | LSP | Language-server configuration | Direct, eagerly loaded. Configures the Neovim LSP integration and Mason-managed servers for TypeScript, Deno, Lua, ESLint, Go, JSON, and Ruby. Loads the Lua LSP settings and disables diagnostic virtual text. |
| `williamboman/mason-lspconfig.nvim` | open | LSP tooling | Mason/LSP bridge | Dependency of `nvim-lspconfig`. Connects Mason-installed servers to Neovim LSP configuration and automatic enablement. |
| `williamboman/mason.nvim` | open | LSP tooling | External-tool installer | Dependency of `nvim-lspconfig`. Installs and manages LSP servers and related tools. |
| `folke/lazydev.nvim` | open | LSP enhancement | Lua and Neovim API metadata | Dependency of `nvim-lspconfig`, loaded for Lua. Supplies Lua library definitions, including `vim.uv`, and is also registered as a Blink completion source. |
| `saghen/blink.cmp` | open | Autocomplete | Completion engine | Direct, eagerly loaded. Provides LSP, LazyDev, path, snippet, and buffer completion, completion navigation, documentation popups, and LSP capability integration. Builds with Cargo. |
| `rafamadriz/friendly-snippets` | open | Snippets | Snippet collection | Dependency of `blink.cmp`. Provides community-maintained snippet definitions. |
| `L3MON4D3/LuaSnip` | open | Snippets | Snippet engine | Direct, pinned to the v2 release line. Builds optional JavaScript regexp support. No explicit Blink integration is configured here. |
| `ray-x/go.nvim` | open | Language tooling | Go development support | Direct, loaded for Go. Adds Go commands and mappings for imports, filling structs, error handling, documentation, and tests. |
| `ray-x/guihua.lua` | open | Language tooling | Go UI dependency | Dependency of `go.nvim`. Supplies UI support used by the Go tooling plugin. |
| `mickael-menu/zk-nvim` | open | Notes/LSP | ZK note-management integration | Direct, loaded for Markdown. Starts the `zk` LSP, attaches in ZK notebooks, uses Telescope for selection, and adds note hover, definition, and diagnostic mappings. |
| `nvim-treesitter/nvim-treesitter` | migrated | Syntax | Parsing, highlighting, indentation | Migrated in Phase 3 to the current main branch. Installs the configured parsers through the `tree-sitter` CLI; Neovim owns highlighting and indentation through native Treesitter APIs. |
| `JoosepAlviste/nvim-ts-context-commentstring` | open | Editing | Context-aware comment strings | Dependency of `Comment.nvim`. Determines the appropriate comment syntax inside embedded Treesitter regions. |
| `numToStr/Comment.nvim` | open | Editing | Comment toggling | Direct. Provides linewise, blockwise, visual, and operator-pending commenting with Treesitter-aware comment strings. |
| `echasnovski/mini.pairs` | open | Editing enhancement | Automatic pairs | Direct, loaded in Insert mode. Inserts matching delimiters automatically. |
| `echasnovski/mini.surround` | open | Editing enhancement | Surround operations | Direct, loaded in Insert mode. Adds, deletes, and replaces surrounding delimiters. |
| `echasnovski/mini.ai` | open | Editing enhancement | Text objects | Direct, loaded before buffer reads. Extends around/inside text objects. |
| `lukas-reineke/indent-blankline.nvim` | open | UI enhancement | Indentation guides | Direct. Displays indentation whitespace, configures custom highlights, and suppresses guides or scope rendering in Markdown and help buffers. |
| `karb94/neoscroll.nvim` | open | Motion enhancement | Smooth scrolling | Direct. Animates scrolling for common half-page movement commands and centering. |
| `NvChad/nvim-colorizer.lua` | open | UI enhancement | Color previews | Direct. Highlights RGB and hexadecimal colors with virtual background previews; named colors, CSS functions, Tailwind colors, and alpha formats are disabled. |
| `MeanderingProgrammer/render-markdown.nvim` | open | Markdown/UI | Rendered Markdown | Direct, loaded for Markdown. Renders headings, bullets, checkboxes, and code blocks inline with custom glyphs, labels, and icons. |
| `goolord/alpha-nvim` | open | UI/dashboard | Startup dashboard | Direct, eagerly loaded. Provides buttons for files, recent files, the configuration, the todo list, and quitting, with custom header and highlights. |
| `kyazdani42/nvim-web-devicons` | open | UI/icons | Filetype icons | Direct and dependency of `alpha-nvim`. Provides icons used by file and UI plugins. |
| `nvim-tree/nvim-web-devicons` | open | UI/icons | Filetype icons | Dependency of `render-markdown.nvim`. Separate repository from the similarly named `kyazdani42` plugin and provides overlapping icon functionality. |
| `catppuccin/nvim` | migrated | Colorscheme | Primary theme | Migrated in Phase 2, priority 1000. The custom Embark-derived dark palette, inactive-window dimming, and integrations were ported as-is. Clock-based light/dark selection now lives in `lua/plugins/colorscheme.lua`. |
| `embark-theme/vim` | deleted | Colorscheme | Embark theme | Was installed but never selected by the theme switcher. Not ported. |
| `EdenEast/nightfox.nvim` | deleted | Colorscheme | Nightfox theme | Compiled a custom Dayfox palette, but its five flavours were unreachable because both light and dark resolved to Catppuccin. Not ported. |
| `nvim-lualine/lualine.nvim` | open | UI/statusline | Statusline and winbar | Direct. Shows mode, branch, diff, filename, Grapple tags, indentation, LSP client count, diagnostics, and Git changes; also configures a path-shortened filename winbar. |
| `nanozuki/tabby.nvim` | open | UI/tabline | Tab and buffer line | Direct. Provides a custom tabline showing working directory, tabs, buffers, changed state, and Grapple keys. |
| `petertriho/nvim-scrollbar` | open | UI/navigation | Scrollbar and signs | Direct. Displays cursor, Git, and change indicators in the active window and integrates with Gitsigns and Zen Mode. |
| `rachartier/tiny-inline-diagnostic.nvim` | open | Diagnostics/UI | Inline diagnostics | Direct, priority 1000. Displays diagnostics inline using the configured non-nerd-font preset. |
| `j-hui/fidget.nvim` | open | LSP/UI | LSP progress | Direct, loaded on `LspAttach`. Displays LSP progress notifications with a dots-pulse spinner and completion marker. |
| `folke/noice.nvim` | open | UI/messages | Command line and message UI | Direct. Provides a popup command line, message history, LSP Markdown rendering, command palette, search UI, and long-message split views. |
| `MunifTanjim/nui.nvim` | open | UI library | UI components | Dependency of `noice.nvim`. Supplies reusable UI components and window primitives. |
| `folke/snacks.nvim` | open | UI/utilities | Notifications | Direct, eagerly loaded with priority 1000. Enables the Snacks notifier and notification history mapping. |
| `stevearc/dressing.nvim` | open | UI/input | Improved input and select UI | Direct, loaded lazily. Replaces basic input UI with improved presentation and disables window blending for inputs. |
| `nvim-telescope/telescope.nvim` | migrated | Search/navigation | Fuzzy finder | Migrated in Phase 3 with lazy key-triggered loading for files, grep, current-buffer search, recent files, diagnostics, marks, and colorschemes. The unused knowledge-base extension was intentionally not ported. |
| `nvim-telescope/telescope-fzf-native.nvim` | migrated | Search | Native fuzzy sorting | Migrated in Phase 3 as a Telescope dependency; its native build and extension loading were verified successfully. |
| `cbochs/grapple.nvim` | open | Navigation/workspace | Tagged-file navigation | Direct and dependency of Lualine and Tabby. Provides Git-scoped file tags, a Telescope extension, tag toggles, and statusline/tabline integration. |
| `nvim-lua/plenary.nvim` | open | Library | Lua utility functions | Dependency of Grapple and Todo Comments. Supplies shared Lua utilities. |
| `folke/which-key.nvim` | deleted | UI/keymaps | Keymap discovery | Direct and dependency of Grapple. Displayed keymap popups, supported grouped mappings, and enabled spelling suggestions while disabling marks integration. Removed in Phase 1 and replaced with the dependency-free popup in `lua/util/keymap_popup.lua`, bound to `<leader>?`. |
| `kyazdani42/nvim-tree.lua` | open | Files | File explorer | Direct, eagerly loaded. Replaces netrw with a Git- and diagnostic-aware file tree, custom file operations, directory handling, and a toggle mapping. |
| `MagicDuck/grug-far.nvim` | open | Search/replace | Project find and replace | Direct, loaded by command. Provides an interactive project-wide replacement interface with normal and visual-mode mappings. |
| `sindrets/diffview.nvim` | open | Git | Diff and history views | Direct, loaded by command. Provides Git diff and history interfaces. |
| `lewis6991/gitsigns.nvim` | open | Git | Git signs and hunks | Direct. Displays add/change/delete signs and provides hunk navigation, preview, reset, diff, blame, and lazygit mappings. |
| `almo7aya/openingh.nvim` | open | Git integration | GitHub links | Direct. Opens the current file or selected lines on GitHub and can copy GitHub URLs. |
| `ojroques/vim-oscyank` | open | Clipboard | OSC52 copy | Direct. Copies visual selections through terminal escape sequences and maps visual copy commands. The configuration notes a possible future move to `nvim-osc52`. |
| `akinsho/toggleterm.nvim` | open | Terminal | Embedded terminal | Direct. Provides a floating terminal, custom hidden terminals for todo and ZK workflows, a `DailyNote` command, and related mappings. |
| `folke/zen-mode.nvim` | open | UI/productivity | Focused editing | Direct. Creates a centered writing view, temporarily disables Git signs and the scrollbar, adjusts Kitty font size, and restores state on exit. |
| `folke/todo-comments.nvim` | open | Workflow/search | TODO and task comments | Direct, with Plenary dependency. Highlights and signs FIX, TODO, HACK, WARN, PERF, NOTE, and TEST comments and provides Telescope search mappings. |
| `stevearc/conform.nvim` | open | Formatting | Formatter orchestration | Direct. Runs formatters for Lua, Python, Rust, Go, JavaScript/TypeScript, JSON, and YAML on save, with LSP fallback and a toggle for automatic formatting. |
| `nvim-lua/popup.nvim` | open | Compatibility | Legacy popup API | Direct. Provides an implementation of Vim's Popup API for Neovim; no local configuration is present. |
| `jparise/vim-graphql` | open | Syntax | GraphQL syntax | Direct, loaded for GraphQL files. Provides GraphQL language syntax support. |

## Plugin-manager infrastructure

| Plugin | Status | Category | Role | Configuration |
|---|---|---|---|---|
| `folke/lazy.nvim` | open | Plugin manager | Installation and loading | Bootstrapped from `lua/user/lazy.lua`. Imports `lua/plugins/`, defaults plugins to lazy loading, disables update checking and change detection, and uses a single-border UI. |

## Declaration relationships and duplicates

| Repository | Direct declarations | Dependency declarations | Notes |
|---|---:|---:|---|
| `cbochs/grapple.nvim` | 1 | 2 | Declared directly in `grapple.lua` and repeated as a dependency of Lualine and Tabby. |
| `folke/which-key.nvim` | 1 | 1 | Declared directly and as a Grapple dependency. |
| `nvim-lua/plenary.nvim` | 0 | 2 | Declared by Grapple and Todo Comments. |
| `nvim-treesitter/nvim-treesitter` | 1 | 1 | Declared directly and as a Markdown-rendering dependency. |
| `kyazdani42/nvim-web-devicons` | 1 | 1 | Declared directly and as an Alpha dependency. |

The repeated declarations are normally deduplicated by Lazy, but they are useful cleanup targets
for the rebuild. The two web-devicons repositories should be evaluated carefully because they are
not the same Lazy repository key.

## External tools and host integrations assumed

The current configuration references or expects the following external tools and integrations:

- `cargo` for Blink's build
- `make` for Telescope FZF native and LuaSnip builds
- `stylua`, `isort`, `black`, `rustfmt`, `gofmt`, `prettier`, and `prettierd` for formatting
- `rg` for Todo Comments and search workflows
- `zk` for notes and the ZK LSP
- `todo` and `lazygit` for terminal workflows
- Kitty remote-control support for Zen Mode font resizing
