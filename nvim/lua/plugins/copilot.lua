-- GitHub Copilot (Lua version - more configurable)
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        -- Suggestion panel (view multiple options)
        panel = {
          enabled = true,
          auto_refresh = true,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
          },
          layout = {
            position = "right",
            ratio = 0.4,
          },
        },

        -- Inline suggestions (ghost text)
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<C-j>",
            accept_word = "<C-Right>",
            accept_line = "<C-l>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-x>",
          },
        },

        -- Filetypes where Copilot is disabled
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },

        copilot_node_command = "node",

        server_opts_overrides = {},
      })
    end,
  },
}
