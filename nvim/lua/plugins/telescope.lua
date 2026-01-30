-- Telescope: Fuzzy finder
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("telescope").setup({
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          width = 0.95,
          height = 0.95,
          preview_width = 0.50,
          horizontal = {
            preview_cutoff = 120,
          },
        },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<C-u>"] = "preview_scrolling_up",
            ["<C-d>"] = "preview_scrolling_down",
          },
          n = {
            ["<C-u>"] = "preview_scrolling_up",
            ["<C-d>"] = "preview_scrolling_down",
          },
        },
        file_ignore_patterns = { "node_modules", ".git/" },
        buffer_previewer_maker = function(filepath, bufnr, opts)
          local previewers = require("telescope.previewers")
          local image_extensions = { "png", "jpg", "jpeg", "gif", "bmp", "webp", "svg", "ico" }
          local extension = vim.fn.fnamemodify(filepath, ":e"):lower()
          local is_image = vim.tbl_contains(image_extensions, extension)

          if is_image then
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(bufnr) then
                local filename = vim.fn.fnamemodify(filepath, ":t")
                vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
                  "",
                  "",
                  "  Image: " .. filename,
                  "",
                  "  Press <Enter> to open",
                  "",
                })
              end
            end)
          else
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

      local git_files = vim.fn.systemlist("git status --porcelain | awk '{print $2}'")

      if #git_files == 0 then
        print("No changed files")
        return
      end

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
}
