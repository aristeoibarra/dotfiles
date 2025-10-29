-- UI and Theme plugins
return {
  -- Kanagawa theme
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none",
              },
            },
          },
        },
        theme = "dragon", -- Load dragon variant
        background = {
          dark = "dragon",
          light = "lotus",
        },
      })
      vim.cmd.colorscheme("kanagawa-dragon")
    end,
  },

  -- Lualine: Statusline (minimal configuration, lazy loaded)
  {
    "nvim-lualine/lualine.nvim",
    lazy = true, -- Don't load on startup
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "rebelot/kanagawa.nvim",
    },
    init = function()
      -- Toggle statusline visibility
      vim.keymap.set("n", "<leader>ts", function()
        if vim.o.laststatus == 0 then
          -- Load lualine if not loaded
          require("lazy").load({ plugins = { "lualine.nvim" } })
          vim.o.laststatus = 3 -- Show statusline
          print("Statusline: ON")
        else
          vim.o.laststatus = 0 -- Hide statusline
          print("Statusline: OFF")
        end
      end, { desc = "Toggle statusline" })
    end,
    config = function()
      require("lualine").setup({
        options = {
          theme = "kanagawa",
          component_separators = "",
          section_separators = "",
          globalstatus = true, -- Single statusline for all windows
        },
        sections = {
          -- Left side: mode + filename
          lualine_a = { "mode" },
          lualine_b = {},
          lualine_c = { { "filename", path = 1 } }, -- Show relative path
          -- Right side: filetype + position
          lualine_x = {
            {
              "filetype",
              colored = false,  -- Ultra minimal: no colors
              icon_only = false, -- Ultra minimal: text only, no icon
            },
          },
          lualine_y = {},
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },
}
