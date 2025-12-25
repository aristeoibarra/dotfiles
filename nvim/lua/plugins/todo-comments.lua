-- Todo-comments: Highlight and search TODO, FIX, HACK, etc.
-- =============================================================================
-- KANAGAWA DRAGON COLORS
-- =============================================================================
-- Red: #c4746e | Green: #8a9a7b | Yellow: #c4b28a | Blue: #8ba4b0
-- Bright Blue: #7fb4ca | Magenta: #938aa9 | Cyan: #7aa89f
-- =============================================================================
return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = true,
    sign_priority = 8,
    keywords = {
      FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
      TODO = { icon = " ", color = "info" },
      HACK = { icon = " ", color = "warning" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = " ", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    },
    colors = {
      error = { "DiagnosticError", "ErrorMsg", "#c4746e" },      -- Red
      warning = { "DiagnosticWarn", "WarningMsg", "#c4b28a" },   -- Yellow
      info = { "DiagnosticInfo", "#7fb4ca" },                    -- Bright Blue
      hint = { "DiagnosticHint", "#8a9a7b" },                    -- Green
      default = { "Identifier", "#938aa9" },                     -- Magenta
      test = { "Identifier", "#7aa89f" },                        -- Cyan
    },
    highlight = {
      before = "",
      keyword = "wide",
      after = "fg",
      pattern = [[.*<(KEYWORDS)\s*:]],
      comments_only = true,
      max_line_len = 400,
      exclude = {},
    },
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
      },
      pattern = [[\b(KEYWORDS):]],
    },
  },
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous TODO" },
    { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find TODOs" },
    { "<leader>fT", "<cmd>TodoTelescope keywords=TODO,FIX<cr>", desc = "Find TODO/FIX" },
  },
}
