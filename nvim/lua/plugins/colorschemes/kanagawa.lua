-- Kanagawa colorscheme (wave, dragon, lotus variants)
-- Activated by `theme` command via ~/.local/state/theme/current

local function read_theme()
  local f = io.open(vim.fn.expand("~/.local/state/theme/current"), "r")
  if f then
    local t = f:read("*l")
    f:close()
    return t or "kanagawa-dragon"
  end
  return "kanagawa-dragon"
end

return {
  "rebelot/kanagawa.nvim",
  priority = 1000,
  config = function()
    local cs = read_theme()
    local is_kanagawa = cs:match("^kanagawa")
    local variant = is_kanagawa and cs:gsub("^kanagawa%-", "") or "dragon"

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

    -- Apply colorscheme (may be kanagawa or a different family)
    local ok = pcall(vim.cmd.colorscheme, cs)
    if not ok then
      vim.notify("Colorscheme '" .. cs .. "' not found, falling back to kanagawa-dragon", vim.log.levels.WARN)
      vim.cmd.colorscheme("kanagawa-dragon")
    end

    -- Set terminal colors for kanagawa variants
    if vim.g.colors_name and vim.g.colors_name:match("^kanagawa") then
      local v = vim.g.colors_name:gsub("^kanagawa%-", "")
      local colors = require("kanagawa.colors").setup({ theme = v }).palette
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
