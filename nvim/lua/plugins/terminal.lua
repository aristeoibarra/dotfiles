-- Integrated terminal - toggleterm.nvim
-- Floating terminal for quick commands

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    lazy = true,
    keys = {
      { "<leader>ot", "<cmd>ToggleTerm direction=float<CR>", desc = "Toggle terminal (floating)" },
      { "<leader>oh", "<cmd>ToggleTerm direction=horizontal size=15<CR>", desc = "Toggle terminal (horizontal)" },
    },
    config = function()
      require("toggleterm").setup({
        size = 15,
        open_mapping = nil,  -- Manual mapping only
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          width = math.floor(vim.o.columns * 0.8),
          height = math.floor(vim.o.lines * 0.8),
          winblend = 0,
        },
      })
    end,
  },
}
