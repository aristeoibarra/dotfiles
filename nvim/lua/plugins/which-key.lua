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
      { "<leader>w", group = "file" },
      { "<leader>q", group = "file" },

      -- File explorer
      { "<leader>e", group = "explorer" },
      { "<leader>eh", desc = "Show nvim-tree help" },

      -- Window management
      { "<leader>s", group = "split" },
      { "<leader>sh", desc = "Horizontal split" },
      { "<leader>sv", desc = "Vertical split" },

      -- Resize windows
      { "<leader>r", group = "resize" },
      { "<leader>rh", desc = "Decrease window width" },
      { "<leader>rl", desc = "Increase window width" },
      { "<leader>rj", desc = "Decrease window height" },
      { "<leader>rk", desc = "Increase window height" },

      -- Terminal
      { "<leader>t", group = "terminal" },

      -- UI Toggles
      { "<leader>u", group = "ui" },
      { "<leader>un", desc = "Toggle line numbers" },
      { "<leader>um", desc = "Toggle mouse support" },
      { "<leader>uw", desc = "Toggle line wrap" },
      { "<leader>uS", desc = "Toggle statusline" },

      -- Diagnostics
      { "<leader>d", group = "diagnostics" },
      { "<leader>da", desc = "Diagnostics (all project)" },
      { "<leader>D", desc = "Diagnostic details" },

      -- LSP & Code
      { "<leader>l", group = "lsp" },
      { "<leader>la", desc = "Load all project files" },

      -- OpenCode
      { "<leader>o", group = "opencode" },

      -- Help & Reference
      { "<leader>?", desc = "Show all keybindings" },
      { "<leader>ch", desc = "Vim cheatsheet" },
    },
  },
}
