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
        transparent = true,
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

}
