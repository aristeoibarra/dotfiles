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
        name = "aristeoibarra",
        path = "/Users/aristeoibarra/Library/Mobile Documents/iCloud~md~obsidian/Documents/aristeoibarra",
      },
      {
        name = "digiin",
        path = "/Users/aristeoibarra/digiin/digiin-documentation",
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
