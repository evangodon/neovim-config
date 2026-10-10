require "config.options"
require "config.keymaps"
require "config.autocmds"

require("features.chezmoi").setup()
require("features.marks").setup()
require("features.scope_buffers").setup()

require "config.lazy"
