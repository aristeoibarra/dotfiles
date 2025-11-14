-- LSP Configuration with fallbacks and utilities
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
          "emmet_ls", -- Emmet for HTML/CSS snippets
        },
        automatic_installation = true,
        handlers = {
          function(server_name)
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            if server_name == "tailwindcss" then
              lspconfig[server_name].setup({
                capabilities = capabilities,
                settings = {
                  tailwindCSS = {
                    experimental = {
                      classRegex = {
                        { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                        { "(?:cn|cx|clsx)\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                        "className\\s*[=:]\\s*[\"'`]([^\"'`]*)[\"'`]",
                        "class\\s*[=:]\\s*[\"'`]([^\"'`]*)[\"'`]",
                      },
                    },
                  },
                },
              })
            else
              lspconfig[server_name].setup({
                capabilities = capabilities,
              })
            end
          end,
        },
      })

      -- Auto-install on startup
      local mr = require("mason-registry")
      if not mr.is_installed("typescript-language-server") then
        vim.cmd("MasonInstall typescript-language-server html-lsp css-lsp tailwindcss-language-server json-lsp prisma-language-server emmet-ls")
      end

      -- Install formatters and linters automatically
      require("mason-tool-installer").setup({
        ensure_installed = {
          "prettier", -- Formatter for web dev
          "stylua", -- Lua formatter
          "eslint_d", -- Fast ESLint (NEW)
          "stylelint", -- CSS linter (NEW)
        },
      })
    end,
  },

  -- LSP Configuration using native Neovim 0.11 API with fallbacks
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lsp_utils = require("utils.lsp")

      -- Setup diagnostics
      lsp_utils.setup_diagnostics()

      -- Setup LSP keymaps globally using LspAttach autocmd
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          lsp_utils.setup_keymaps(ev.buf)
        end,
      })

      -- ========================================================================
      -- LSP SERVERS CONFIGURED BY MASON-LSPCONFIG
      -- ========================================================================
      -- All servers are already configured in mason.nvim plugin config

      -- ========================================================================
      -- COMMANDS
      -- ========================================================================

      -- Improved LspStatus command using utils
      vim.api.nvim_create_user_command("LspStatus", function()
        lsp_utils.log_lsp_status()
      end, {})

      -- LspInfo alias
      vim.api.nvim_create_user_command("LspInfo", function()
        lsp_utils.log_lsp_status()
      end, {})

      -- Load all project files for full LSP scanning (from keymaps.lua)
      vim.api.nvim_create_user_command("LspLoadAll", function()
        lsp_utils.log_info("Loading all project files for LSP scan...")
        local find_cmd = "find . -type f \\( -name '*.ts' -o -name '*.tsx' -o -name '*.js' -o -name '*.jsx' -o -name '*.html' -o -name '*.css' -o -name '*.scss' -o -name '*.json' -o -name '*.prisma' \\) 2>/dev/null | grep -v node_modules | grep -v .git | grep -v coverage | grep -v dist | grep -v build"
        local files = vim.fn.systemlist(find_cmd)

        if #files == 0 then
          lsp_utils.log_warn("No files found to load")
          return
        end

        lsp_utils.log_info(string.format("Found %d files. Loading...", #files))

        local batch_size = 50
        local total = #files
        local loaded = 0

        local function load_batch(start_idx)
          local end_idx = math.min(start_idx + batch_size - 1, total)
          for i = start_idx, end_idx do
            local bufnr = vim.fn.bufadd(files[i])
            if bufnr > 0 then
              vim.fn.bufload(bufnr)
              loaded = loaded + 1
            end
          end

          if end_idx < total then
            vim.defer_fn(function()
              load_batch(end_idx + 1)
            end, 100)
          else
            vim.defer_fn(function()
              lsp_utils.log_info(string.format("Loaded %d/%d files. LSP scanning complete.", loaded, total))
            end, 1000)
          end
        end

        load_batch(1)
      end, {})
    end,
  },
}
