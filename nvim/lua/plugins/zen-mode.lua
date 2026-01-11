-- Zen Mode: Distraction-free coding optimized for BenQ GW2780 27" 1920x1080
return {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
    },
    opts = {
      window = {
        backdrop = 1.0, -- Full backdrop for 27" monitor
        width = 140, -- Optimized for 27" 1920x1080 (wider for comfortable reading)
        height = 1, -- 100% height
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
          laststatus = 0, -- No statusline in zen mode
        },
        tmux = { enabled = false }, -- Keep tmux status visible
        alacritty = {
          enabled = false, -- Keep current font settings
        },
        gitsigns = { enabled = false },
      },
      on_open = function(win)
        -- Complete UI cleanup
        vim.opt.laststatus = 0
        vim.opt.number = false
        vim.opt.relativenumber = false
        vim.opt.signcolumn = "no"
        vim.opt.cursorline = false
        vim.opt.cmdheight = 0
      end,
      on_close = function()
        -- Restore UI (match options.lua defaults)
        vim.opt.laststatus = 3
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.signcolumn = "yes"
        vim.opt.cursorline = true
        vim.opt.cmdheight = 0 -- noice.nvim handles cmdline
      end,
    },
  },
}
