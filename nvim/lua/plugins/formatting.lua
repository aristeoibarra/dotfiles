-- Formatting and Linting - conform.nvim + nvim-lint
return {
  -- ============================================================================
  -- FORMATTER: conform.nvim (Prettier + Stylua)
  -- ============================================================================
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")

      -- Prettier formatter configuration
      conform.formatters.prettier = {
        command = "prettier",
        args = { "--stdin-filepath", "$FILENAME", "--config-precedence", "prefer-file" },
        stdin = true,
        condition = function(ctx)
          -- Check if prettier is available
          return vim.fn.executable("prettier") == 1
        end,
      }

      conform.setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          css = { "prettier" },
          scss = { "prettier" },
          less = { "prettier" },
          html = { "prettier" },
          json = { "prettier" },
          jsonc = { "prettier" },
          yaml = { "prettier" },
          lua = { "stylua" },
        },

        -- Format on save (async not supported in format_on_save, must be false)
        format_on_save = function(bufnr)
          -- Don't format very large files (>1MB)
          local max_filesize = 1024 * 1024
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
          if ok and stats and stats.size > max_filesize then
            return
          end

          return {
            timeout_ms = 500,
            lsp_fallback = true,
            async = false,     -- Conform requires async=false for format_on_save
          }
        end,

        -- Default format options for all formatters
        default_format_opts = {
          lsp_fallback = true,
          async = true,
          timeout_ms = 500,
        },
      })

      -- Manual formatting keymap (improved)
      vim.keymap.set({ "n", "v" }, "<leader>cf", function()
        conform.format({
          async = true,
          timeout_ms = 500,
          lsp_fallback = true,
        })
      end, { desc = "Format file or range" })
    end,
  },

  -- ============================================================================
  -- LINTER: nvim-lint (ESLint + Stylelint)
  -- ============================================================================
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile", "BufWritePost" },
    config = function()
      local lint = require("lint")

      -- Configure linters by filetype
      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        css = { "stylelint" },
        scss = { "stylelint" },
        less = { "stylelint" },
      }

      -- Create augroup for linting
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      -- Auto-lint on save
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      -- Auto-lint on insert leave (when you finish editing)
      vim.api.nvim_create_autocmd("InsertLeave", {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      -- Manual linting command
      vim.api.nvim_create_user_command("LintFile", function()
        lint.try_lint()
        vim.notify("Linting complete", vim.log.levels.INFO)
      end, {})
    end,
  },

  -- ============================================================================
  -- TOOL INSTALLER: Auto-install formatters and linters
  -- ============================================================================
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Formatters
          "prettier",       -- JS/TS/CSS/HTML/JSON/YAML/MD
          "stylua",         -- Lua

          -- Linters
          "eslint_d",       -- Fast ESLint (NEW)
          "stylelint",      -- CSS linter (NEW)
        },
      })
    end,
  },
}
