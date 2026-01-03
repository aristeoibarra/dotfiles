-- NvimTree: File explorer
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    local function on_attach(bufnr)
      local api = require("nvim-tree.api")

      -- Default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- Disable arrow keys
      local opts = { buffer = bufnr, noremap = true, silent = true }
      vim.keymap.set("n", "<Up>", "<Nop>", opts)
      vim.keymap.set("n", "<Down>", "<Nop>", opts)
      vim.keymap.set("n", "<Left>", "<Nop>", opts)
      vim.keymap.set("n", "<Right>", "<Nop>", opts)
    end

    require("nvim-tree").setup({
      on_attach = on_attach,
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
