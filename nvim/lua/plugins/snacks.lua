-- Snacks.nvim: Dashboard + utilities
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- Dashboard configuration
    dashboard = {
      enabled = false,
    },

    -- Bigfile (disable features on large files)
    bigfile = {
      enabled = true,
      size = 512 * 1024, -- 512KB (aggressive for 8GB RAM)
    },

    -- Notifier (notifications)
    notifier = {
      enabled = true,
      timeout = 3000,
    },

    -- Input (disabled - use native cmdline for confirmations)
    input = {
      enabled = false,
    },

    -- Picker (for other plugins)
    picker = {
      enabled = true,
    },

    -- Terminal
    terminal = {
      enabled = true,
    },

    -- Quickfile (fast file opening)
    quickfile = {
      enabled = true,
    },

    -- Statuscolumn
    statuscolumn = {
      enabled = false,
    },

    -- Words (highlight word under cursor)
    words = {
      enabled = true,
    },
  },
  keys = {
    { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>ud", function() Snacks.notifier.hide() end, desc = "Dismiss Notifications" },
  },
}
