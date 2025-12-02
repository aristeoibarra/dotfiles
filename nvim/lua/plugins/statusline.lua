-- Statusline: Minimal lualine configuration with toggle (hidden by default)
return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Configuration for lualine
      local function setup_lualine()
        require("lualine").setup({
          options = {
            icons_enabled = true,
            theme = "kanagawa",
            component_separators = { left = "│", right = "│" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = {
              statusline = { "NvimTree", "DiffviewFiles", "Neogit", "neo-tree" },
              winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = true, -- Single statusline for all windows (27" optimization)
            refresh = {
              statusline = 1000,
              tabline = 1000,
              winbar = 1000,
            },
          },

          -- Left section: mode + branch + file
          sections = {
            lualine_a = {
              {
                "mode",
                fmt = function(str)
                  return str:sub(1, 1)  -- Single letter (N, I, V, etc)
                end,
              },
            },
            lualine_b = {
              {
                "branch",
                icon = "",
                fmt = function(str)
                  return str:sub(1, 20)  -- Limit branch name to 20 chars
                end,
              },
              {
                "diff",
                symbols = { added = " ", modified = " ", removed = " " },
                cond = function()
                  return vim.fn.winwidth(0) > 80
                end,
              },
            },
            lualine_c = {
              {
                function()
                  local filepath = vim.fn.expand("%:p")  -- Full path
                  local cwd = vim.fn.getcwd()

                  -- Make path relative to cwd
                  if filepath:sub(1, #cwd) == cwd then
                    filepath = filepath:sub(#cwd + 2)  -- Remove cwd and the separator
                  end

                  -- Get modified indicator
                  local modified = vim.bo.modified and " [+]" or ""
                  local readonly = vim.bo.readonly and " [-]" or ""

                  return filepath .. modified .. readonly
                end,
                cond = function()
                  return vim.fn.winwidth(0) > 80
                end,
              },
            },

            -- Right section: LSP + filetype + position
            lualine_x = {
              {
                "diagnostics",
                symbols = { error = "E", warn = "W", info = "I", hint = "H" },
                cond = function()
                  return vim.fn.winwidth(0) > 80
                end,
              },
              {
                function()
                  local clients = vim.lsp.get_clients({ bufnr = 0 })
                  if #clients == 0 then
                    return ""
                  end

                  -- Show only count of active servers with a compact icon
                  return "󰌘 " .. #clients
                end,
                cond = function()
                  return vim.fn.winwidth(0) > 80
                end,
              },
              {
                "filetype",
                fmt = function(str)
                  return str:upper():sub(1, 2)  -- 2-char filetype (TS, JS, PY, etc)
                end,
              },
            },
            lualine_y = {
              {
                "progress",
                fmt = function(str)
                  return str:sub(1, 3)  -- Show percentage (999)
                end,
              },
            },
            lualine_z = {
              {
                "location",
                fmt = function()
                  local line = vim.fn.line(".")
                  local col = vim.fn.col(".")
                  return string.format("%d:%d", line, col)
                end,
              },
            },
          },

          -- Inactive statusline (for other windows)
          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { { "filename", path = 1 } },
            lualine_x = { "filetype" },
            lualine_y = {},
            lualine_z = {},
          },

          -- No tabline
          tabline = {},

          -- No winbar
          winbar = {},
          inactive_winbar = {},

          extensions = { "nvim-tree", "toggleterm" },
        })
      end

      -- Only setup lualine if laststatus is not 0 (i.e., not hidden)
      if vim.opt.laststatus:get() ~= 0 then
        setup_lualine()
      end

      -- Toggle command - setup/teardown lualine based on laststatus
      vim.api.nvim_create_user_command("ToggleStatusline", function()
        if vim.opt.laststatus:get() == 0 then
          vim.opt.laststatus = 2
          setup_lualine()
        else
          vim.opt.laststatus = 0
        end
      end, {})

      -- Create keymap for toggle (uS = UI -> Statusline)
      vim.keymap.set("n", "<leader>uS", "<cmd>ToggleStatusline<cr>", {
        noremap = true,
        silent = true,
        desc = "Toggle statusline visibility",
      })
    end,
  },
}
