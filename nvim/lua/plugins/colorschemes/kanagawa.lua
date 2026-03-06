-- Kanagawa colorscheme (wave, dragon, lotus variants)
-- Activated by `theme` command via ~/.local/state/theme/

local state_dir = vim.fn.expand("~/.local/state/theme")

local function read_file(path)
  local f = io.open(path, "r")
  if f then
    local t = f:read("*l")
    f:close()
    return t
  end
  return nil
end

return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local theme_name = read_file(state_dir .. "/current") or "kanagawa-dragon"
    local is_kanagawa = theme_name:match("^kanagawa")
    local variant = is_kanagawa and theme_name:gsub("^kanagawa%-", "") or "dragon"

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
      theme = variant,
      background = {
        dark = variant == "lotus" and "dragon" or variant,
        light = "lotus",
      },
    })

    if is_kanagawa then
      local cs = read_file(state_dir .. "/nvim_colorscheme") or "kanagawa-dragon"
      vim.cmd.colorscheme(cs)

      local colors = require("kanagawa.colors").setup({ theme = variant }).palette
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
    end
  end,
}
