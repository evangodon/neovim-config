local M = {
  "giusgad/pets.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "edluffy/hologram.nvim",
  },
  event = "VeryLazy",
  enabled = false,
}

function M.config()
  -- TODO: fix https://github.com/edluffy/hologram.nvim/issues/25
  require("pets").setup({})
end

return M
