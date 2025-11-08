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

      -- Setup LSP servers using stable lspconfig API
      local lspconfig = require("lspconfig")

      -- TypeScript/JavaScript
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
      })

      -- HTML
      lspconfig.html.setup({
        capabilities = capabilities,
      })

      -- CSS
      lspconfig.cssls.setup({
        capabilities = capabilities,
      })

      -- Tailwind CSS with custom class regex for cva/cx
      lspconfig.tailwindcss.setup({
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

      -- JSON
      lspconfig.jsonls.setup({
        capabilities = capabilities,
      })

      -- Prisma
      lspconfig.prismals.setup({
        capabilities = capabilities,
      })
    end,
  },
}
