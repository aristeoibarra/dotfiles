-- Termux Neovim (Ultra-Light, No Plugins)

-- Leader
vim.g.mapleader = " "

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = true              -- wrap en pantalla pequeña
vim.opt.linebreak = true         -- no cortar palabras
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 4
vim.opt.signcolumn = "no"        -- más espacio horizontal
vim.opt.showmode = false
vim.opt.laststatus = 1           -- statusline solo si hay splits
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true

-- Colorscheme (built-in, no download needed)
vim.cmd.colorscheme("habamax")

-- Keymaps esenciales
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>")
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>")
vim.keymap.set("n", "<leader>e", "<cmd>Ex<cr>")        -- netrw explorer
vim.keymap.set("n", "<Esc>", "<cmd>noh<cr>")

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Buffer navigation
vim.keymap.set("n", "<Tab>", "<cmd>bn<cr>")
vim.keymap.set("n", "<S-Tab>", "<cmd>bp<cr>")
vim.keymap.set("n", "<leader>x", "<cmd>bd<cr>")

-- Move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Better indent
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Quick find files (netrw, simple and reliable)
vim.keymap.set("n", "<leader>f", "<cmd>Ex<cr>")

-- Search in files
vim.keymap.set("n", "<leader>g", ":vimgrep //g **/*<Left><Left><Left><Left><Left><Left><Left><Left>")

-- Netrw settings (built-in file explorer)
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25
