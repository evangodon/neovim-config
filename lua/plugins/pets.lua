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
  require("pets").setup({})
end

return M
