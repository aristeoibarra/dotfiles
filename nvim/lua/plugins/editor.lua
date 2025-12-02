-- Editor enhancement plugins
return {
  -- Which-key: Show keybindings (ultra minimal)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 300, -- Balanced delay for advanced users (responsive but not intrusive)
      icons = {
        breadcrumb = "",
        separator = " ",
        group = "",
        mappings = false,
      },
      win = {
        border = "none",
        padding = { 0, 1 },
        wo = {
          winblend = 0,
        },
      },
      layout = {
        spacing = 3,
      },
      spec = {
        -- File operations
        { "<leader>w", group = "file" },
        { "<leader>q", group = "file" },

        -- File explorer
        { "<leader>e", group = "explorer" },
        { "<leader>eh", desc = "Show nvim-tree help" },

        -- Window management
        { "<leader>s", group = "split" },
        { "<leader>sh", desc = "Horizontal split" },
        { "<leader>sv", desc = "Vertical split" },

        -- Resize windows
        { "<leader>r", group = "resize" },
        { "<leader>rh", desc = "Decrease window width" },
        { "<leader>rl", desc = "Increase window width" },
        { "<leader>rj", desc = "Decrease window height" },
        { "<leader>rk", desc = "Increase window height" },

        -- Terminal
        { "<leader>t", group = "terminal" },

        -- UI Toggles
        { "<leader>u", group = "ui" },
        { "<leader>un", desc = "Toggle line numbers" },
        { "<leader>um", desc = "Toggle mouse support" },
        { "<leader>uw", desc = "Toggle line wrap" },
        { "<leader>uS", desc = "Toggle statusline" },

        -- Diagnostics
        { "<leader>d", group = "diagnostics" },
        { "<leader>da", desc = "Diagnostics (all project)" },
        { "<leader>D", desc = "Diagnostic details" },

        -- LSP & Code
        { "<leader>l", group = "lsp" },
        { "<leader>la", desc = "Load all project files" },

        -- Help & Reference
        { "<leader>?", desc = "Show all keybindings" },
        { "<leader>ch", desc = "Vim cheatsheet" },
      }
    },
  },

  -- Treesitter: Better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "typescript",
          "tsx",
          "javascript",
          "html",
          "css",
          "json",
          "prisma",
          "lua",
          "vim",
          "markdown",
        },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },

  -- Auto-close and auto-rename HTML/JSX tags
  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = false, -- Auto close on trailing </
        },
      })
    end,
  },

  -- Auto-close brackets, parens, quotes
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = true, -- Enable treesitter
        ts_config = {
          lua = { "string" }, -- Don't add pairs in lua string treesitter nodes
          javascript = { "template_string" },
          java = false, -- Don't check treesitter on java
        },
      })

      -- Integration with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

}
