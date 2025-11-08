-- Colorizer: display hex, rgb, rgba colors
return {
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        "*", -- Apply to all files
        css = { css = true },
        scss = { css = true },
        sass = { css = true },
        javascript = { css = true },
        javascriptreact = { css = true },
        typescript = { css = true },
        typescriptreact = { css = true },
        html = { css = true },
      }, {
        RGB = true,
        RRGGBB = true,
        names = false, -- Disabled to avoid interfering with Tailwind
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
      })
    end,
  },
}
