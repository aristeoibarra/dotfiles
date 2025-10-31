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
      vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Find diagnostics (project)" })

      -- Find changed files with diff preview
      vim.keymap.set("n", "<leader>fc", function()
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local previewers = require("telescope.previewers")
        local putils = require("telescope.previewers.utils")

        -- Get git changed files
        local git_files = vim.fn.systemlist("git status --porcelain | awk '{print $2}'")

        if #git_files == 0 then
          print("No changed files")
          return
        end

        -- Custom previewer for diff
        local diff_previewer = previewers.new_buffer_previewer({
          title = "Git Diff",
          define_preview = function(self, entry)
            local diff = vim.fn.systemlist("git diff HEAD " .. vim.fn.shellescape(entry.value))
            if #diff > 0 then
              vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, diff)
              putils.highlighter(self.state.bufnr, "diff")
            else
              vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, { "No diff available" })
            end
          end,
        })

        pickers.new({}, {
          prompt_title = "Changed Files",
          finder = finders.new_table({
            results = git_files,
            entry_maker = function(entry)
              local git_status = vim.fn.system("git status --porcelain " .. vim.fn.shellescape(entry)):sub(1, 2)
              local indicator = ""
              if git_status:match("M") then
                indicator = " M"
              elseif git_status:match("??") then
                indicator = " U"
              elseif git_status:match("A") then
                indicator = " A"
              end
              return {
                value = entry,
                display = entry .. indicator,
                ordinal = entry,
                path = entry,
              }
            end,
          }),
          sorter = conf.generic_sorter({}),
          previewer = diff_previewer,
        }):find()
      end, { desc = "Find changed files (git)" })
    end,
  },

  -- nvim-tree: File explorer (optimized ultraminimal)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Disable netrw
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        -- Ultra minimal view
        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = true,
        sync_root_with_cwd = true,

        view = {
          width = 30,
          side = "left",
          number = false,
          relativenumber = false,
        },

        renderer = {
          indent_markers = {
            enable = false,
          },
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
          custom = { "^.git$" },
        },

        actions = {
          open_file = {
            quit_on_open = false,
            window_picker = {
              enable = true,
            },
          },
        },

        git = {
          enable = false,
          ignore = true,
        },

        diagnostics = {
          enable = false,
        },
      })

      -- Keymap
      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
      vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", { desc = "Find file in tree" })
    end,
  },
}
