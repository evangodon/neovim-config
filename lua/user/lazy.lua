local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "git@github.com:folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

vim.g.mapleader = " "

require("lazy").setup("plugins", {
  defaults = { lazy = true },
  checker = { enabled = false },
  change_detection = {
    enabled = false,
  },
  debug = false,
  ui = {
    border = "single"
  }
})

require("user.functions").register_key_map({ L = {
  CMD "Lazy",
  "Open Lazy manager",
} })
