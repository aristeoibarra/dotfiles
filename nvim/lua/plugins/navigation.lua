-- Navigation plugins
return {
  -- Telescope: Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
          -- Ultra minimal: show clean message for images, preview text normally
          buffer_previewer_maker = function(filepath, bufnr, opts)
            local previewers = require("telescope.previewers")

            -- Check if file is an image
            local image_extensions = { "png", "jpg", "jpeg", "gif", "bmp", "webp", "svg", "ico" }
            local extension = vim.fn.fnamemodify(filepath, ":e"):lower()
            local is_image = vim.tbl_contains(image_extensions, extension)

            if is_image then
              -- Show clean message for images (ultra minimal)
              vim.schedule(function()
                if vim.api.nvim_buf_is_valid(bufnr) then
                  local filename = vim.fn.fnamemodify(filepath, ":t")
                  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
                    "",
                    "",
                    "  Image file",
                    "",
                    "  " .. filename,
                    "",
                    "  Press <Enter> to open",
                    "",
                  })
                end
              end)
            else
              -- Use default previewer for text files
              previewers.buffer_previewer_maker(filepath, bufnr, opts)
            end
          end,
        },
      })

      -- Keymaps
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
    end,
  },

  -- nvim-tree: File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      -- Disable netrw
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = false, -- Disabled for ultra minimal (no git status icons)
            },
          },
        },
        filters = {
          dotfiles = false,
        },
      })

      -- Keymap
      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    end,
  },
}
