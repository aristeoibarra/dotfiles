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

      -- Diagnostics
      { "<leader>d", desc = "Diagnostics list" },
      { "<leader>D", desc = "Diagnostic float" },

      -- LSP & Code
      { "<leader>l", group = "lsp" },
      { "<leader>c", group = "code" },

      -- Git
      { "<leader>g", group = "git" },
      { "<leader>h", group = "hunk" },

      -- Harpoon
      { "<leader>m", group = "harpoon" },

      -- Multicursor
      { "<leader>M", group = "multicursor" },

      -- Flash (s and S are mapped directly, no leader)

      -- DAP/Debug
      { "<leader>b", desc = "Toggle breakpoint" },

      -- OpenCode
      { "<leader>o", group = "opencode" },

      -- Obsidian
      { "<leader>O", group = "obsidian" },

      -- Zen mode
      { "<leader>z", desc = "Zen mode" },

      -- Help & Reference
      { "<leader>?", desc = "All keybindings" },
    },
  },
}
