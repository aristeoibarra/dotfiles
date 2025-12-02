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

      -- Force terminal colors to match Kanagawa Dragon
      local colors = require("kanagawa.colors").setup({ theme = "dragon" }).palette
      vim.g.terminal_color_0 = colors.sumiInk0
      vim.g.terminal_color_1 = colors.sakuraRed
      vim.g.terminal_color_2 = colors.springGreen
      vim.g.terminal_color_3 = colors.oniViolet
      vim.g.terminal_color_4 = colors.crystalBlue
      vim.g.terminal_color_5 = colors.oniViolet
      vim.g.terminal_color_6 = colors.waveAqua1
      vim.g.terminal_color_7 = colors.sumiInk1
      vim.g.terminal_color_8 = colors.sumiInk4
      vim.g.terminal_color_9 = colors.peachRed
      vim.g.terminal_color_10 = colors.springGreen
      vim.g.terminal_color_11 = colors.carpYellow
      vim.g.terminal_color_12 = colors.springBlue
      vim.g.terminal_color_13 = colors.waveViolet1
      vim.g.terminal_color_14 = colors.waveAqua2
      vim.g.terminal_color_15 = colors.fujiWhite
    end,
  },

}
