# TODO

## Bug

## Workflow

## ZK

- [ ] Improve the Add new note keymap so that it works in any notebook

## DX

<!-- - [-] Disable Gitsigns in gutter for markdown -->

## UI

- [ ] Add autocmd for fish_indent on fish files
- [ ] Fix highlight group for markdown links
- [ ] Use winbar to show file name and path, use nvim-gps, need Neovim 0.8. See https://github.com/SmiteshP/nvim-navic
- [ ] diagnostics float window borders

## Plugins

- [ ] Create permalinks https://github.com/ruifm/gitlinker.nvim
- [ ] Use vale as null-ls source https://bhupesh.me/writing-like-a-pro-with-vale-and-neovim/
- [ ] nvim-surround
- [ ] eyeliner which is a lua version of quick-scope
- [ ] https://github.com/sindrets/diffview.nvim
- [ ] https://github.com/cbochs/grapple.nvim
- [ ] https://github.com/stevearc/resession.nvim

## Productivity

- Command to open url under cursor
- Figure out a todo manager
  - Neorg

---

# Done

- [x] Remove diagnostics from lualine? don't seem to look at them much
- [x] Fix icons in nvim-tree (diagnostics)
- [x] Add keybindings for moving between buffers
- [x] Refactor packer files, move plugins to top
- [x] Code navigation doc
- [x] Add italics
- [x] Find good light theme
- [x] Show scrollbar with diagnostics
- [x] Add dashboard plugin
- [x] Confirm quit when only one buffer left
- [x] Add plugin to remember sessions
- [x] leader key mappings for git actions
- [x] How to find and replace multiple words without lsp and :s
- [x] Show root folder in lualine
- [x] Configure fine-cmdline plugin
- [x] remember last cursor position when opening a file, use autocommand and marks
- [x] Set up github copilot
- [x] Fix d keymap on macbook (don't add a "disabled" string to a keymap)
- [x] Disable Github Copilot for telescope
- [x] Go to next buffer when closing
- [x] Use go.nvim lsp since it has better defaults
- [!] Formatting is slow, test out async formatting... ok it's slow when I open a large folder
- [x] change bg of inactive window, reference https://gist.github.com/ctaylo21/c3620a945cee6fc3eb3cb0d7f57faf00
- [x] Improve telescope performance by using fzf-native
- [x] Show line indents with plugin
- [x] Show root folder in nvim-tree with catppuccin theme
- [x] Add keybindings for packer and LSP, like LspRestart
- [x] Fix signcolumns for inactive windows
- [x] Make Visual highlight less dark
- [x] Fix UI of zenmode, side windows are grey
- [x] Set up packer snapshots, see https://www.reddit.com/r/neovim/comments/um3epn/what_are_your_prizedfavorite_lua_functions/
- [x] https://github.com/ahmedkhalf/project.nvim
- [x] configure alpha dashboard plugin
- [x] Find some way to detect if file is managed by chezmoi
- [x] Add command to Alpha dash to Packer Sync
- [x] Fix floating term background color and use lazygit plugin
- [x] Create keybinding to follow links for zk notes
- [x] Fix fuzzy search of current window
- [x] Telescope
      -- [x] Place prompt to top, see here https://github.com/NvChad/NvChad/blob/main/lua/plugins/configs/telescope.lua
      -- [-] Configure border characterst to add horizontal padding
- [x] Partial highlight link with GitSignColumn https://www.reddit.com/r/neovim/comments/oxddk9/how_do_i_get_the_value_from_a_highlight_group/
- [x] make background dark for toggle term
- [x] Add background color to border between windows
- [x] Create keymap for `Telescope oldfiles` and to open up multiple files at once
- Barbar
  -- [X] Change color of buffer not saved (yellow right now)
  -- [X] Change color of BufferPick letter
- [x] Close all buffers but this one, need to create function for this https://codereview.stackexchange.com/questions/268130/get-list-of-buffers-from-current-neovim-instance
- [x] https://github.com/romgrk/barbar.nvim
- [x] use arrows for navigating in cmp menu
- [x] Look into group feature https://github.com/mickael-menu/zk/blob/main/docs/config-group.md
- [x] new template for media files
- [x] Use ui components to improve creation of notes, compare dressing.nvim and nui.nvim
- [x] Bufferline select letter is still sometimes red, and bg is somethings wrong, can't hardcode that color
- [x] Enable prettier formatting on markdown files
- [x] Smart DD https://www.reddit.com/r/neovim/comments/w0jzzv/smart_dd/
- [x] Use winbar to show path of open buffer https://github.com/rcarriga/dotfiles/blob/master/.config/nvim/init.lua#L46-L66
- [x] Replace scrollbar plugin with https://github.com/lewis6991/satellite.nvim or https://github.com/petertriho/nvim-scrollbar
- [x] The chezmoi autocmd shows output at the top which is annoying
