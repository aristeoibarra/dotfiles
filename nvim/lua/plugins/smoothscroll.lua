-- Smooth scrolling for better visual comfort on 27" @ 82 PPI
return {
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
      local neoscroll = require("neoscroll")

      neoscroll.setup({
        -- Smooth scroll settings optimized for 27" monitor
        hide_cursor = false, -- Keep cursor visible (better for tracking)
        stop_eof = true, -- Stop at end of file
        respect_scrolloff = true, -- Respect scrolloff setting
        cursor_scrolls_alone = true, -- Cursor moves independently
        easing = "sine", -- Natural, smooth movement (updated API)
        performance_mode = false,
      })

      -- Keymaps using modern API (neoscroll-helper-functions)
      local keymap = {
        ["<C-u>"] = function() neoscroll.ctrl_u({ duration = 100 }) end,
        ["<C-d>"] = function() neoscroll.ctrl_d({ duration = 100 }) end,
        ["<C-b>"] = function() neoscroll.ctrl_b({ duration = 150 }) end,
        ["<C-f>"] = function() neoscroll.ctrl_f({ duration = 150 }) end,
        ["zt"] = function() neoscroll.zt({ half_win_duration = 50 }) end,
        ["zz"] = function() neoscroll.zz({ half_win_duration = 50 }) end,
        ["zb"] = function() neoscroll.zb({ half_win_duration = 50 }) end,
      }

      local modes = { "n", "v", "x" }
      for key, func in pairs(keymap) do
        vim.keymap.set(modes, key, func)
      end
    end,
  },
}
