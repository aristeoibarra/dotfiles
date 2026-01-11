-- Basic Neovim options

-- Line numbers (relative numbers active by default for better navigation)
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- UI
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes" -- Single signcolumn
vim.opt.foldcolumn = "0" -- No fold column
vim.opt.numberwidth = 2 -- Minimum width for line numbers
vim.opt.scrolloff = 16
vim.opt.cursorline = true
vim.opt.wrap = true
vim.opt.linebreak = true -- Wrap at word boundaries (better for long Tailwind classes)
vim.opt.breakindent = true -- Maintain indentation on wrapped lines
vim.opt.showbreak = "↪ " -- Show indicator for wrapped lines
vim.opt.cmdheight = 0 -- Hidden, noice.nvim handles cmdline
vim.opt.mouse = "a" -- Enable mouse (useful for multicursor, resizing splits, etc.)
vim.opt.laststatus = 3 -- Global statusline always visible (optimized for 27" monitor)

-- Files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Split windows
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Update time (longer for 8+ hour sessions - reduces energy usage)
vim.opt.updatetime = 500
vim.opt.timeoutlen = 300

-- Completion
vim.opt.completeopt = "menu,menuone,noselect"

-- Concealing (disabled for better clarity on 81 PPI non-Retina display)
vim.opt.conceallevel = 0

-- Disable intro message
vim.opt.shortmess:append("I")

-- Line spacing (optimized for 8+ hours programming on 27" monitor @ 82 PPI)
vim.opt.linespace = 5

-- Note: Diagnostics config is in utils/lsp.lua
-- Note: netrw is disabled by nvim-tree plugin
