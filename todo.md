# TODO

## Bug 

## Workflow
- [ ] Add notification if editing a file managed by chezmoi

## DX

- [ ] Set up packer snapshots, see https://www.reddit.com/r/neovim/comments/um3epn/what_are_your_prizedfavorite_lua_functions/
- [ ] How to persist folds
- [ ] Test out another session manager https://github.com/Shatur/neovim-session-manager

- [-] Disable Gitsigns in gutter for markdown
- [-] configure alpha dashboard plugin
- [-] Figure out why Nvimtree sometimes open file in window

## UI
- [ ] Fix signcolumns for inactive windows
- [ ] Use winbar to show file name and path, use nvim-gps, need Neovim 0.8. See https://github.com/SmiteshP/nvim-navic
- [ ] Make Visual highlight less dark
- [ ] Use winbar to show path of open buffer https://github.com/rcarriga/dotfiles/blob/master/.config/nvim/init.lua#L46-L66
- [ ] diagnostics float window borders 
- [ ] make background dark for toggle term
- [ ] Change color of internal errors with highlight


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
