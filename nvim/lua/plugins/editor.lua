-- Editor enhancement plugins
return {
  -- Which-key: Show keybindings (ultra minimal)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 300,
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
        -- Descriptive groups for learning
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Git Hunks" },
        { "<leader>a", group = "AI Assistants" },
        { "<leader>o", group = "Obsidian Notes" },
        { "<leader>d", group = "Diagnostics" },
        { "<leader>t", group = "Toggle UI" },
        { "<leader>s", group = "Splits" },
        { "<leader>r", group = "Resize" },
        { "<leader>c", group = "Code/Cheatsheet" },
        { "<leader>e", group = "Explorer" },
        { "<leader>l", group = "LSP Utils" },
        { "g", group = "Go to (Navigation)" },
        { "]", group = "Next" },
        { "[", group = "Previous" },
      },
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
