-- Snacks.nvim: Dashboard + utilities
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- Dashboard configuration
    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        { section = "startup" },
      },
      preset = {
        header = [[

      ████ ██████           █████      ██
     ███████████             █████
     █████████ ███████████████████ ███   ███████████
    █████████  ███    █████████████ █████ ██████████████
   █████████ ██████████ █████████ █████ █████ ████ █████
 ███████████ ███    ███ █████████ █████ █████ ████ █████
██████  █████████████████████ ████ █████ █████ ████ ██████
        ]],
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":Telescope live_grep" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
          { icon = " ", key = "c", desc = "Config", action = function() vim.cmd("e " .. vim.fn.stdpath("config") .. "/init.lua") end },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },

    -- Notifier (notifications)
    notifier = {
      enabled = true,
      timeout = 3000,
    },

    -- Input (better vim.ui.input)
    input = {
      enabled = true,
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
