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

      -- Define LSP servers manually using vim.lsp.config (Neovim 0.11 native API)
      local servers = {
        ts_ls = {
          cmd = { "typescript-language-server", "--stdio" },
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
          root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
        },
        html = {
          cmd = { "vscode-html-language-server", "--stdio" },
          filetypes = { "html" },
          root_markers = { "package.json", ".git" },
        },
        cssls = {
          cmd = { "vscode-css-language-server", "--stdio" },
          filetypes = { "css", "scss", "less" },
          root_markers = { "package.json", ".git" },
        },
        tailwindcss = {
          cmd = { "tailwindcss-language-server", "--stdio" },
          filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact" },
          root_markers = { "tailwind.config.js", "tailwind.config.ts", ".git" },
        },
        jsonls = {
          cmd = { "vscode-json-language-server", "--stdio" },
          filetypes = { "json", "jsonc" },
          root_markers = { ".git" },
        },
      }

      -- Configure and enable each server
      for server_name, config in pairs(servers) do
        vim.lsp.config(server_name, {
          cmd = config.cmd,
          filetypes = config.filetypes,
          root_markers = config.root_markers,
          capabilities = capabilities,
        })
        vim.lsp.enable(server_name)
      end
    end,
  },
}
