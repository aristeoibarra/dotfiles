-- Zen Mode: Distraction-free coding (manual activation only)
-- For focused writing sessions without any UI

return {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
    },
    opts = {
      window = {
        backdrop = 1.0,
        width = 100,
        height = 1,
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = "0",
          list = false,
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
          laststatus = 0,
        },
        tmux = { enabled = false },
        alacritty = { enabled = false },
        gitsigns = { enabled = false },
      },
      on_open = function()
        vim.opt.laststatus = 0
        vim.opt.number = false
        vim.opt.relativenumber = false
        vim.opt.signcolumn = "no"
        vim.opt.cursorline = false
        vim.opt.cmdheight = 0
      end,
      on_close = function()
        vim.opt.laststatus = 3
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.signcolumn = "yes"
        vim.opt.cursorline = true
        vim.opt.cmdheight = 0
      end,
    },
  },
}
