-- Obsidian.nvim - Neovim plugin for writing and navigating Obsidian vaults
-- https://github.com/epwalsh/obsidian.nvim
--
-- Features:
-- - Autocompletion for wiki links ([[...]]), markdown links ([...]()), and tags (#...)
-- - Navigate notes with 'gf' on links (Ctrl+o to go back, Ctrl+i to go forward)
-- - Fuzzy search notes across vaults with Telescope integration
-- - Multiple workspace support for different Obsidian vaults
-- - UI enhancements: concealing markdown syntax for cleaner reading (similar to preview mode)
--
-- Requirements:
-- - ripgrep (installed via Homebrew)
-- - plenary.nvim (dependency)
-- - telescope.nvim (for pickers/search)
-- - nvim-cmp (for completion)

return {
  "epwalsh/obsidian.nvim",
  version = "*", -- Use latest stable release
  lazy = true, -- Load only when needed
  ft = "markdown", -- Load only for markdown files
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required: Lua utility functions
    "nvim-telescope/telescope.nvim", -- Required: Picker for search/navigation
  },
  opts = {
    -- Workspaces: Define multiple Obsidian vaults (digiin is default)
    workspaces = {
      {
        name = "digiin",
        path = "/Users/aristeoibarra/digiin/digiin-documentation",
      },
      {
        name = "personal",
        path = "/Users/aristeoibarra/Library/Mobile Documents/iCloud~md~obsidian/Documents/aristeoibarra",
      },
    },

    -- Completion: Enable nvim-cmp integration for note links and tags
    -- Triggers: [[ for wiki links, [ for markdown links, # for tags
    completion = { nvim_cmp = true },

    -- UI: Enable syntax enhancements (concealing, checkboxes, etc.)
    -- Makes markdown more readable by hiding syntax characters (similar to Obsidian preview mode)
    -- Note: Requires 'conceallevel = 2' in options.lua
    ui = { enable = true },

    -- Mappings: Custom keybindings for markdown files
    mappings = {
      -- gf: Follow link under cursor (works with wiki links, markdown links, and file paths)
      -- Use Ctrl+o to go back, Ctrl+i to go forward in jump history
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
    },
  },

  -- Keymaps: Lazy-loaded shortcuts (only available when plugin is loaded)
  keys = {
    { "<leader>of", "<cmd>ObsidianQuickSwitch<cr>", desc = "Find notes" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search vault" },
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
    -- Quick workspace switching (minimal)
    { "<leader>od", "<cmd>ObsidianWorkspace digiin<cr>", desc = "Digiin vault" },
    { "<leader>op", "<cmd>ObsidianWorkspace personal<cr>", desc = "Personal vault" },
    { "<leader>ow", "<cmd>ObsidianWorkspace<cr>", desc = "Switch workspace" },
  },
}
