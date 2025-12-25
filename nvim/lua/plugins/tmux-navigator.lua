-- Seamless navigation between Neovim and Tmux panes
return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<CR>", desc = "Navigate left (tmux-aware)" },
    { "<C-j>", "<cmd>TmuxNavigateDown<CR>", desc = "Navigate down (tmux-aware)" },
    { "<C-k>", "<cmd>TmuxNavigateUp<CR>", desc = "Navigate up (tmux-aware)" },
    { "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Navigate right (tmux-aware)" },
  },
}
