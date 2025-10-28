-- Session management with persistence.nvim
return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- Only load when a file is opened
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"), -- Directory where session files are saved
      options = { "buffers", "curdir", "tabpages", "winsize" }, -- What to save
      pre_save = nil, -- Function to run before saving
      save_empty = false, -- Don't create a session for empty buffers
    },
    keys = {
      -- Restore the session for the current directory
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },

      -- Restore the last session
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore Last Session",
      },

      -- Stop persistence (don't save current session on exit)
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
  },
}
