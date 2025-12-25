-- NvimTree: File explorer
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("nvim-tree").setup({
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      sync_root_with_cwd = true,

      view = {
        width = 40,
        side = "left",
        number = false,
        relativenumber = false,
      },

      renderer = {
        indent_markers = { enable = false },
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = false,
          },
          glyphs = {
            folder = {
              arrow_closed = "▸",
              arrow_open = "▾",
            },
          },
        },
      },

      filters = {
        dotfiles = false,
        git_ignored = true,
        custom = { "^.git$", "^node_modules$", "^.next$", "^dist$", "^build$", "^coverage$" },
      },

      actions = {
        open_file = {
          quit_on_open = true,
          window_picker = { enable = true },
        },
      },

      git = { enable = false, ignore = true },
      diagnostics = { enable = false },
    })

    vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
  end,
}
