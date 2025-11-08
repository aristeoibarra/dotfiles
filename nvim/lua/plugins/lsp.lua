-- LSP Configuration
return {
  -- Mason: LSP server and tool manager
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls", -- TypeScript/JavaScript
          "html", -- HTML
          "cssls", -- CSS
          "tailwindcss", -- Tailwind CSS
          "jsonls", -- JSON
          "prismals", -- Prisma
        },
        automatic_installation = true,
      })

      -- Install formatters automatically
      require("mason-tool-installer").setup({
        ensure_installed = {
          "prettier", -- Formatter for web dev
        },
      })
    end,
  },

  -- LSP Configuration using native Neovim 0.11 API
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Setup LSP keymaps globally using LspAttach autocmd
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
          vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
          vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Go to references" }))

          -- Go to definition in splits
          vim.keymap.set("n", "gv", function()
            vim.cmd('vsplit')
            vim.lsp.buf.definition()
          end, vim.tbl_extend("force", opts, { desc = "Go to definition in vertical split" }))

          vim.keymap.set("n", "gs", function()
            vim.cmd('split')
            vim.lsp.buf.definition()
          end, vim.tbl_extend("force", opts, { desc = "Go to definition in horizontal split" }))
        end,
      })

      -- Setup LSP servers using Neovim 0.11+ native API
      -- Note: nvim-lspconfig is now deprecating in favor of vim.lsp.config()

      -- TypeScript/JavaScript
      vim.lsp.config("ts_ls", {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
        capabilities = capabilities,
      })
      vim.lsp.enable("ts_ls")

      -- HTML
      vim.lsp.config("html", {
        cmd = { "vscode-html-language-server", "--stdio" },
        filetypes = { "html" },
        root_markers = { "package.json", ".git" },
        capabilities = capabilities,
      })
      vim.lsp.enable("html")

      -- CSS
      vim.lsp.config("cssls", {
        cmd = { "vscode-css-language-server", "--stdio" },
        filetypes = { "css", "scss", "less" },
        root_markers = { "package.json", ".git" },
        capabilities = capabilities,
      })
      vim.lsp.enable("cssls")

      -- Tailwind CSS with custom class regex for cva/cx
      vim.lsp.config("tailwindcss", {
        cmd = { "tailwindcss-language-server", "--stdio" },
        filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_markers = { "tailwind.config.js", "tailwind.config.ts", ".git" },
        capabilities = capabilities,
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                "class[:]\\s*?[\"'`]([^\"'`]*).*?[\"'`]",
              },
            },
          },
        },
      })
      vim.lsp.enable("tailwindcss")

      -- JSON
      vim.lsp.config("jsonls", {
        cmd = { "vscode-json-language-server", "--stdio" },
        filetypes = { "json", "jsonc" },
        root_markers = { ".git" },
        capabilities = capabilities,
      })
      vim.lsp.enable("jsonls")

      -- Prisma
      vim.lsp.config("prismals", {
        cmd = { "prisma-language-server", "--stdio" },
        filetypes = { "prisma" },
        root_markers = { "package.json", ".git" },
        capabilities = capabilities,
      })
      vim.lsp.enable("prismals")
    end,
  },
}
