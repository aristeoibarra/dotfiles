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

  -- Claude Code Neovim integration
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      terminal = {
        split_side = "right",           -- Panel on the right
        split_width_percentage = 0.25,  -- 25% of window width (more compact)
      },
    },
    config = function(_, opts)
      require("claudecode").setup(opts)

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
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}
