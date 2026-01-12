-- Statusline: Minimalist Gentleman-style with incline.nvim
-- Mode-only statusline + floating filename

-- Mode abbreviations
local mode_map = {
  ["NORMAL"] = "N",
  ["O-PENDING"] = "N?",
  ["INSERT"] = "I",
  ["VISUAL"] = "V",
  ["V-BLOCK"] = "VB",
  ["V-LINE"] = "VL",
  ["V-REPLACE"] = "VR",
  ["REPLACE"] = "R",
  ["COMMAND"] = "!",
  ["SHELL"] = "SH",
  ["TERMINAL"] = "T",
  ["EX"] = "X",
  ["S-BLOCK"] = "SB",
  ["S-LINE"] = "SL",
  ["SELECT"] = "S",
  ["CONFIRM"] = "Y?",
  ["MORE"] = "M",
}

-- Mode component with formatting
local mode_component = {
  "mode",
  fmt = function(s)
    return mode_map[s] or s
  end,
}

-- OpenCode adapter info (for AI chat buffers)
local function opencode_status()
  local ok, opencode = pcall(require, "opencode")
  if not ok then
    return nil
  end
  -- Check if we're in an opencode buffer
  local bufname = vim.fn.bufname()
  if bufname:match("opencode") or vim.bo.filetype == "opencode" then
    return " AI"
  end
  return nil
end

return {
  -- =========================================================================
  -- LUALINE: Minimalist statusline (Gentleman-style)
  -- =========================================================================
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    priority = 900,
    config = function()
      vim.opt.laststatus = 3 -- Enable global statusline
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "kanagawa",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          globalstatus = true,
        },

        -- Full statusline
        sections = {
          lualine_a = { mode_component },
          lualine_b = { "branch", "diff" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "diagnostics", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },

        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "filetype" },
          lualine_y = {},
          lualine_z = {},
        },

        -- Extensions for contextual statuslines
        extensions = {
          "quickfix",
          -- NvimTree extension
          {
            filetypes = { "NvimTree" },
            sections = {
              lualine_a = { mode_component },
              lualine_b = {
                function()
                  return " Explorer"
                end,
              },
              lualine_c = {},
              lualine_x = {},
              lualine_y = {},
              lualine_z = {},
            },
          },
          -- Terminal extension
          {
            filetypes = { "toggleterm", "terminal" },
            sections = {
              lualine_a = { mode_component },
              lualine_b = {
                function()
                  return " Terminal"
                end,
              },
              lualine_c = {},
              lualine_x = {},
              lualine_y = {},
              lualine_z = {},
            },
          },
          -- Neogit extension
          {
            filetypes = { "NeogitStatus", "NeogitCommitMessage" },
            sections = {
              lualine_a = { mode_component },
              lualine_b = {
                function()
                  return " Git"
                end,
              },
              lualine_c = {},
              lualine_x = {},
              lualine_y = {},
              lualine_z = {},
            },
          },
          -- Diffview extension
          {
            filetypes = { "DiffviewFiles", "DiffviewFileHistory" },
            sections = {
              lualine_a = { mode_component },
              lualine_b = {
                function()
                  return " Diff"
                end,
              },
              lualine_c = {},
              lualine_x = {},
              lualine_y = {},
              lualine_z = {},
            },
          },
          -- Trouble extension
          {
            filetypes = { "Trouble" },
            sections = {
              lualine_a = { mode_component },
              lualine_b = {
                function()
                  return " Diagnostics"
                end,
              },
              lualine_c = {},
              lualine_x = {},
              lualine_y = {},
              lualine_z = {},
            },
          },
          -- Telescope extension
          {
            filetypes = { "TelescopePrompt" },
            sections = {
              lualine_a = { mode_component },
              lualine_b = {
                function()
                  return " Search"
                end,
              },
              lualine_c = {},
              lualine_x = {},
              lualine_y = {},
              lualine_z = {},
            },
          },
          -- Lazy extension
          {
            filetypes = { "lazy" },
            sections = {
              lualine_a = { mode_component },
              lualine_b = {
                function()
                  return "󰒲 Lazy"
                end,
              },
              lualine_c = {},
              lualine_x = {},
              lualine_y = {},
              lualine_z = {},
            },
          },
          -- Mason extension
          {
            filetypes = { "mason" },
            sections = {
              lualine_a = { mode_component },
              lualine_b = {
                function()
                  return " Mason"
                end,
              },
              lualine_c = {},
              lualine_x = {},
              lualine_y = {},
              lualine_z = {},
            },
          },
          -- Help extension
          {
            filetypes = { "help" },
            sections = {
              lualine_a = { mode_component },
              lualine_b = {
                function()
                  return "󰋖 Help"
                end,
              },
              lualine_c = {
                function()
                  return vim.fn.expand("%:t")
                end,
              },
              lualine_x = {},
              lualine_y = { "progress" },
              lualine_z = { "location" },
            },
          },
        },
      })

      -- Toggle command to completely hide/show statusline
      vim.api.nvim_create_user_command("StatuslineToggle", function()
        if vim.o.laststatus == 0 then
          -- Show statusline
          vim.o.laststatus = 3
          require("lualine").hide({ unhide = true })
        else
          -- Completely hide statusline
          vim.o.laststatus = 0
          require("lualine").hide()
        end
      end, {})

      vim.keymap.set("n", "<leader>uS", "<cmd>StatuslineToggle<cr>", {
        desc = "Toggle statusline (minimal/full)",
      })
    end,
  },

}
