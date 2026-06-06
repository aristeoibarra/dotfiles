-- Main init.lua for Neovim configuration

-- Load basic options
require("config.options")

-- Load keymaps
require("config.keymaps")

-- Load autocmds
require("config.autocmds")

-- Setup lazy.nvim and load plugins
require("config.lazy")
