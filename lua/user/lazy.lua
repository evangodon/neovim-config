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
  defaults = { lazy = false },
  checker = { enabled = false },
  change_detection = {
    enabled = false,
  },
  debug = false,
})