local M = {
  "giusgad/pets.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "edluffy/hologram.nvim",
  },
  event = "VeryLazy",
  enabled = true,
}

function M.config()
  require("pets").setup({
    row = 5, -- the row (height) to display the pet at (higher row means the pet is lower on the screen), must be 1<=row<=10
    col = 0, -- the column to display the pet at (set to high number to have it stay still on the right side)
    speed_multiplier = 1, -- you can make your pet move faster/slower. If slower the animation will have lower fps.
    default_pet = "crab", -- the pet to use for the PetNew command
    default_style = "red", -- the style of the pet to use for the PetNew command
    random = true, -- whether to use a random pet for the PetNew command, overrides default_pet and default_style
  })
end

return M
