-- Catppuccin colorscheme
-- Activated by `theme` command via ~/.local/state/theme/

return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup({})

    local f = io.open(vim.fn.expand("~/.local/state/theme/current"), "r")
    if f then
      local theme = f:read("*l")
      f:close()
      if theme and theme:match("^catppuccin") then
        local cf = io.open(vim.fn.expand("~/.local/state/theme/nvim_colorscheme"), "r")
        if cf then
          local cs = cf:read("*l")
          cf:close()
          if cs then vim.cmd.colorscheme(cs) end
        end
      end
    end
  end,
}
