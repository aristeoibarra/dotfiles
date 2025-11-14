-- Basic Neovim options

-- Line numbers (hidden by default, can toggle with <leader>tn)
vim.opt.number = false
vim.opt.relativenumber = false

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
vim.opt.signcolumn = "no"
vim.opt.scrolloff = 8
vim.opt.cursorline = true
vim.opt.wrap = true
vim.opt.linebreak = true -- Wrap at word boundaries (better for long Tailwind classes)
vim.opt.breakindent = true -- Maintain indentation on wrapped lines
vim.opt.showbreak = "↪ " -- Show indicator for wrapped lines
vim.opt.cmdheight = 1
vim.opt.mouse = "" -- Disable mouse by default (use <leader>tm to toggle)
vim.opt.laststatus = 0 -- Statusline hidden by default (toggle with <leader>ts)

-- Files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Split windows
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Completion
vim.opt.completeopt = "menu,menuone,noselect"

-- Concealing (for Obsidian.nvim UI features)
vim.opt.conceallevel = 2

-- Disable intro message
vim.opt.shortmess:append("I")

-- Line spacing (reduce if too much space between lines)
vim.opt.linespace = 0

-- Diagnostics (inline error display)
vim.diagnostic.config({
  virtual_text = {
    prefix = "", -- Ultra minimal: no prefix
    spacing = 4,
    source = "if_many", -- Show source if multiple sources
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E", -- Ultra minimal: letters only (was: Nerd Font icon)
      [vim.diagnostic.severity.WARN] = "W",  -- Ultra minimal: letters only (was: Nerd Font icon)
      [vim.diagnostic.severity.HINT] = "H",  -- Ultra minimal: letters only (was: Nerd Font icon)
      [vim.diagnostic.severity.INFO] = "I",  -- Ultra minimal: letters only (was: Nerd Font icon)
    },
  },
  underline = true,
  update_in_insert = false, -- Don't update diagnostics while typing
  severity_sort = true, -- Show errors before warnings
  float = {
    border = "rounded",
    source = "always", -- Show source in floating window
    header = "",
    prefix = "",
  },
})

-- Note: netrw is disabled by nvim-tree plugin
