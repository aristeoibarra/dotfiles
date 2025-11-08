-- Obsidian.nvim - Neovim plugin for Obsidian note-taking
-- IMPORTANT: Customize the workspace paths below to match your Obsidian vaults
return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = vim.fn.expand("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/personal"),
      },
      {
        name = "work",
        path = vim.fn.expand("~/work/documentation"),
      },
    },
    legacy_commands = false,
    footer = {
      enabled = false,
    },
  },
  keys = {
    { "<leader>of", "<cmd>Obsidian quick_switch<cr>", desc = "Find notes" },
    { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search vault" },
    { "<leader>on", "<cmd>Obsidian new<cr>", desc = "New note" },
    { "<leader>ow", "<cmd>Obsidian workspace<cr>", desc = "Switch workspace" },
  },
}
