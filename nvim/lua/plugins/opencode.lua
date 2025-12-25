-- OpenCode AI - Coding assistant integrado en Neovim
return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  keys = {
    -- Toggle
    {
      "<leader>oo",
      function()
        require("opencode").toggle()
      end,
      mode = { "n" },
      desc = "Toggle OpenCode",
    },
    -- Seleccionar y enviar
    {
      "<leader>os",
      function()
        require("opencode").select({ submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode select",
    },
    -- Preguntar
    {
      "<leader>oi",
      function()
        require("opencode").ask("", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode ask",
    },
    -- Preguntar con contexto
    {
      "<leader>oI",
      function()
        require("opencode").ask("@this: ", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode ask with context",
    },
    -- Preguntar sobre buffer
    {
      "<leader>ob",
      function()
        require("opencode").ask("@file ", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode ask about buffer",
    },
    -- Prompt con contexto
    {
      "<leader>op",
      function()
        require("opencode").prompt("@this", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode prompt",
    },
    -- Prompts predefinidos
    {
      "<leader>oe",
      function()
        require("opencode").prompt("explain", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode explain",
    },
    {
      "<leader>of",
      function()
        require("opencode").prompt("fix", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode fix",
    },
    {
      "<leader>od",
      function()
        require("opencode").prompt("diagnose", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode diagnose",
    },
    {
      "<leader>or",
      function()
        require("opencode").prompt("review", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode review",
    },
    {
      "<leader>ot",
      function()
        require("opencode").prompt("test", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode test",
    },
    {
      "<leader>oz",
      function()
        require("opencode").prompt("optimize", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode optimize",
    },
  },
  config = function()
    vim.g.opencode_opts = {
      provider = {
        snacks = {
          win = {
            position = "left",
          },
        },
      },
    }
    vim.o.autoread = true
  end,
}
