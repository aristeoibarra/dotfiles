-- Formatting and Linting - conform.nvim + nvim-lint
return {
  -- ============================================================================
  -- FORMATTER: conform.nvim (Prettier + Stylua)
  -- ============================================================================
  {
    "stevearc/conform.nvim",
    lazy = false,
    config = function()
      local conform = require("conform")

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
        format_on_save = {
          timeout_ms = 10000,
          lsp_format = "never",
        },
        notify_on_error = true,
        notify_no_formatters = true,
      })

      -- Función para formatear con prettier directamente
      local function format_with_prettier()
        local bufnr = vim.api.nvim_get_current_buf()
        local ft = vim.bo[bufnr].filetype

        -- Mapeo de filetype a parser de prettier
        local parsers = {
          json = "json",
          jsonc = "json",
          javascript = "babel",
          typescript = "typescript",
          javascriptreact = "babel",
          typescriptreact = "typescript",
          css = "css",
          scss = "scss",
          less = "less",
          html = "html",
          yaml = "yaml",
        }

        local parser = parsers[ft]
        if not parser then
          -- Usar conform para otros filetypes (como lua con stylua)
          require("conform").format({ timeout_ms = 10000, lsp_format = "never" })
          return
        end

        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local content = table.concat(lines, "\n")

        local result = vim.fn.system("prettier --parser " .. parser, content)

        if vim.v.shell_error ~= 0 then
          vim.notify("Prettier error", vim.log.levels.ERROR)
          return
        end

        local new_lines = vim.split(result, "\n", { trimempty = false })
        if new_lines[#new_lines] == "" then
          table.remove(new_lines)
        end

        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
      end

      -- Keymap para formatear
      vim.keymap.set({ "n", "v" }, "<leader>cf", format_with_prettier, { desc = "Format file" })

      -- Format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
        pattern = { "*.json", "*.js", "*.ts", "*.jsx", "*.tsx", "*.css", "*.scss", "*.html", "*.yaml", "*.yml" },
        callback = format_with_prettier,
      })
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
