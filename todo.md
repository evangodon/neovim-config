# TODO

## Bug 

## Workflow
- [ ] Switch to vim mode for fish shell

## DX
- [ ] Test out another session manager https://github.com/Shatur/neovim-session-manager
- [ ] Close all buffers but this one, need to create function for this https://codereview.stackexchange.com/questions/268130/get-list-of-buffers-from-current-neovim-instance

<!-- - [-] Disable Gitsigns in gutter for markdown -->
<!-- - [-] Figure out why Nvimtree sometimes open file in window -->
<!-- - [-] How to persist folds -->
<!-- - [-] Disable <C-t> in NvimTree, instead always open Telescrope live grep -->

## UI
- [ ] Partial highlight link with GitSignColumn https://www.reddit.com/r/neovim/comments/oxddk9/how_do_i_get_the_value_from_a_highlight_group/
- [ ] Add autocmd for fish_indent on fish files
- [ ] Fix highlight group for markdown links
- [ ] Use winbar to show file name and path, use nvim-gps, need Neovim 0.8. See https://github.com/SmiteshP/nvim-navic
- [ ] Use winbar to show path of open buffer https://github.com/rcarriga/dotfiles/blob/master/.config/nvim/init.lua#L46-L66
- [ ] diagnostics float window borders 
- [ ] make background dark for toggle term
- [ ] Make NvimTreeCursorLine go all the way to end of buffer https://github.com/neovim/neovim/issues/14473

## Plugins
- [ ] https://github.com/romgrk/barbar.nvim
- [ ] Replace scrollbar plugin with https://github.com/lewis6991/satellite.nvim
- [ ] Create permalinks https://github.com/ruifm/gitlinker.nvim
- [ ] Use vale as null-ls source https://bhupesh.me/writing-like-a-pro-with-vale-and-neovim/

## Productivity
- Command to open url under cursor
- Figure out a todo manager
  - Neorg
  - zk.nvim


---


# Done
- [X] Remove diagnostics from lualine? don't seem to look at them much
- [X] Fix icons in nvim-tree (diagnostics)
- [X] Add keybindings for moving between buffers
- [X] Refactor packer files, move plugins to top
- [X] Code navigation doc
- [X] Add italics 
- [X] Find good light theme
- [X] Show scrollbar with diagnostics
- [X] Add dashboard plugin
- [X] Confirm quit when only one buffer left
- [X] Add plugin to remember sessions
- [X] leader key mappings for git actions
- [X] How to find and replace multiple words without lsp and :s
- [X] Show root folder in lualine
- [X] Configure fine-cmdline plugin
- [X] remember last cursor position when opening a file, use autocommand and marks
- [X] Set up github copilot
- [X] Fix d keymap on macbook (don't add a "disabled" string to a keymap)
- [X] Disable Github Copilot for telescope
- [X] Go to next buffer when closing
- [X] Use go.nvim lsp since it has better defaults
- [!] Formatting is slow, test out async formatting... ok it's slow when I open a large folder
- [X] change bg of inactive window, reference  https://gist.github.com/ctaylo21/c3620a945cee6fc3eb3cb0d7f57faf00
- [X] Improve telescope performance by using fzf-native
- [X] Show line indents with plugin
- [X] Show root folder in nvim-tree with catppuccin theme
- [X] Add keybindings for packer and LSP, like LspRestart
- [X] Fix signcolumns for inactive windows
- [X] Make Visual highlight less dark
- [X] Fix UI of zenmode, side windows are grey
- [X] Set up packer snapshots, see https://www.reddit.com/r/neovim/comments/um3epn/what_are_your_prizedfavorite_lua_functions/
- [X] https://github.com/ahmedkhalf/project.nvim 
- [X] configure alpha dashboard plugin
- [X] Find some way to detect if file is managed by chezmoi
- [X] Add command to Alpha dash to Packer Sync
- [X] Fix floating term background color and use lazygit plugin
- [X] Create keybinding to follow links for zk notes
- [X] Fix fuzzy search of current window
- [X] Telescope
  -- [X] Place prompt to top, see here https://github.com/NvChad/NvChad/blob/main/lua/plugins/configs/telescope.lua
  -- [-] Configure border characterst to add horizontal padding 
