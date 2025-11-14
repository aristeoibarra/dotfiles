-- Claude Code AI Assistant
return {
  -- Snacks.nvim dependency for claudecode
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Basic snacks configuration
      bigfile = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = false },
      words = { enabled = true },
    },
  },

  -- Claude Code Neovim integration (OPTIMIZED)
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      -- Server configuration
      port_range = { min = 10000, max = 65535 },
      auto_start = true,
      log_level = "warn",  -- Reduced logs for faster performance

      -- Terminal configuration
      terminal = {
        split_side = "right",
        split_width_percentage = 0.20,
        provider = "snacks",  -- Explicit for performance
        auto_close = true,

        -- Enhanced snacks window options
        snacks_win_opts = {
          position = "right",
          border = "rounded",
          title = " Claude Code ",
          title_pos = "center",
          keys = {
            claude_hide = {
              "<C-,>",
              function(self) self:hide() end,
              mode = "t",
              desc = "Hide Claude",
            },
          },
        },
      },

      -- Workspace configuration (CRITICAL - fixes multi-project context)
      git_repo_cwd = true,

      -- Selection tracking (enhanced context awareness)
      track_selection = true,
      visual_demotion_delay_ms = 30,
      focus_after_send = true,

      -- Connection optimization (optimized for speed)
      connection_wait_delay = 300,
      connection_timeout = 8000,
      queue_timeout = 3000,

      -- Diff configuration (professional workflow)
      diff_opts = {
        layout = "vertical",
        open_in_new_tab = false,
        keep_terminal_focus = false,
        hide_terminal_in_new_tab = false,
        on_new_file_reject = "close_window",
      },
    },
    config = function(_, opts)
      require("claudecode").setup(opts)

      -- Command to maximize Claude split
      vim.api.nvim_create_user_command("ClaudeMaximize", function()
        -- Make editor window 20% of screen width, Claude gets 80%
        vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.20))
      end, {})

      -- Command to minimize Claude split back to normal
      vim.api.nvim_create_user_command("ClaudeMinimize", function()
        -- Restore to normal split: editor 80%, Claude 20%
        vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.80))
      end, {})

      -- Add terminal keymaps for Claude Code terminal after it opens
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "*",
        callback = function()
          -- Only apply to Claude Code terminal
          if vim.bo.filetype == "claudecode" or string.match(vim.api.nvim_buf_get_name(0), "claudecode") then
            local bufnr = vim.api.nvim_get_current_buf()
            -- Easy exit from terminal mode
            vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { buffer = bufnr, desc = 'Exit terminal mode' })
            -- Navigate to other windows from terminal
            vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { buffer = bufnr, desc = 'Move to left window' })
            vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', { buffer = bufnr, desc = 'Move to right window' })
            vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', { buffer = bufnr, desc = 'Move to bottom window' })
            vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', { buffer = bufnr, desc = 'Move to top window' })
          end
        end,
      })
    end,
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      -- Core commands
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeMaximize<cr>", desc = "Maximize Claude" },
      { "<leader>aF", "<cmd>ClaudeMinimize<cr>", desc = "Minimize Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },

      -- Context management
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },

      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },

      -- Additional commands
      { "<leader>aS", "<cmd>ClaudeCodeStatus<cr>", desc = "Status" },
      { "<leader>ao", "<cmd>ClaudeCodeOpen<cr>", desc = "Open Claude" },
      { "<leader>aq", "<cmd>ClaudeCodeClose<cr>", desc = "Close Claude" },
      { "<leader>ax", "<cmd>ClaudeCodeStop<cr>", desc = "Stop server" },
    },
  },
}
