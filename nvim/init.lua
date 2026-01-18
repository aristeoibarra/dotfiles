-- Main init.lua for Neovim configuration

-- Add Mason bin to PATH (required for LSP servers)
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

-- Load basic options
require("config.options")

-- Load keymaps
require("config.keymaps")

-- Load autocmds
require("config.autocmds")

-- Setup lazy.nvim and load plugins
require("config.lazy")
