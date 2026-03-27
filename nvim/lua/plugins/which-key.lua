-- Which-key: Show keybindings popup
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "classic",
    delay = 300,
    icons = {
      breadcrumb = "»",
      separator = "→",
      group = "+",
      mappings = true,
    },
    win = {
      border = "single",
      padding = { 1, 2 },
      wo = {
        winblend = 0,
      },
    },
    layout = {
      spacing = 3,
    },
    spec = {
      -- File operations
      { "<leader>w", desc = "Save file" },
      { "<leader>q", desc = "Quit" },

      -- Find/Search
      { "<leader>f", group = "find" },

      -- File explorer
      { "<leader>e", group = "explorer" },

      -- Window management
      { "<leader>s", group = "split" },

      -- Resize windows
      { "<leader>r", group = "resize" },

      -- Terminal
      { "<leader>t", group = "terminal" },

      -- UI Toggles
      { "<leader>u", group = "ui" },

      -- Buffer operations
      { "<leader>b", group = "buffer" },

      -- Git
      { "<leader>g", group = "git" },
      { "<leader>h", group = "hunk" },

      -- Zen mode
      { "<leader>z", desc = "Zen mode" },

      -- Help & Reference
      { "<leader>?", desc = "All keybindings" },
    },
  },
}
