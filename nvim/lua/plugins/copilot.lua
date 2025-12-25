-- GitHub Copilot (Lua version - más configurable)
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        -- Panel de sugerencias (ver múltiples opciones)
        panel = {
          enabled = true,
          auto_refresh = true,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>", -- Alt+Enter abre panel
          },
          layout = {
            position = "right",
            ratio = 0.4,
          },
        },

        -- Sugerencias inline (ghost text)
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<C-j>",           -- Igual que tenías
            accept_word = "<C-Right>",  -- Aceptar solo una palabra
            accept_line = "<C-l>",      -- Aceptar solo una línea
            next = "<M-]>",             -- Siguiente sugerencia
            prev = "<M-[>",             -- Anterior sugerencia
            dismiss = "<C-x>",          -- Descartar
          },
        },

        -- Filetypes donde Copilot está deshabilitado
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

        -- Copilot node command
        copilot_node_command = "node",

        -- Servidor LSP
        server_opts_overrides = {},
      })
    end,
  },
}
