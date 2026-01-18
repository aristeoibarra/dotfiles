-- Flash.nvim: Ultra-fast navigation
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    labels = "asdfghjklqwertyuiopzxcvbnm",
    search = {
      multi_window = true,
      forward = true,
      wrap = true,
    },
    jump = {
      jumplist = true,
      pos = "start",
      autojump = false,
    },
    label = {
      uppercase = false,
      rainbow = {
        enabled = false,
      },
    },
    modes = {
      search = {
        enabled = false, -- Don't override default /
      },
      char = {
        enabled = true,
        jump_labels = true,
      },
    },
  },
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash jump",
    },
    {
      "S",
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash treesitter",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Flash remote",
    },
    {
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Flash treesitter search",
    },
  },
}
