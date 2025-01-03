local M = {
  {
    -- Pairs
    "echasnovski/mini.pairs",
    version = "*",
    event = "InsertEnter",
    config = function()
      require("mini.pairs").setup()
    end,
  },
  {
    -- Surround
    "echasnovski/mini.surround",
    version = "*",
    event = "InsertEnter",
    config = function()
      require("mini.surround").setup()
    end,
  },
  {
    "echasnovski/mini.ai",
    version = "*",
    event = "BufReadPre",
    config = function()
      require("mini.ai").setup()
    end,
  },
}

return M
