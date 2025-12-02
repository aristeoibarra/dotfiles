-- Git plugins - Gitsigns (hunks) + Neogit (UI) + Diffview (diff viewer)
return {
  -- ============================================================================
  -- GITSIGNS: Git hunks inline (line-by-line git changes)
  -- ============================================================================
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        -- Current line blame (toggle with <leader>hB)
        current_line_blame = false,  -- Off by default
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",  -- End of line
          delay = 500,  -- 500ms delay before showing
          ignore_whitespace = true,
        },
        current_line_blame_formatter = " <author>, <author_time:%Y-%m-%d> - <summary>",
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation (hunks)
          map("n", "]h", function()
            if vim.wo.diff then
              return "]h"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Next hunk" })

          map("n", "[h", function()
            if vim.wo.diff then
              return "[h"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Previous hunk" })

          -- Hunk actions
          map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
          map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
          map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
          map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end, { desc = "Blame line (popup)" })
          map("n", "<leader>hB", gs.toggle_current_line_blame, { desc = "Toggle blame (inline)" })
          map("n", "<leader>hd", gs.diffthis, { desc = "Diff hunk" })
        end,
      })
    end,
  },

  -- ============================================================================
  -- NEOGIT: Git UI and workflows (status, commits, branches, stash, etc)
  -- ============================================================================
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local neogit = require("neogit")

      neogit.setup({
        disable_signs = false,
        disable_context_highlighting = false,
        disable_commit_confirmation = false,
        auto_refresh = true,
        kind = "split",
        console_timeout = 2000,
        auto_show_console = false,
        status = {
          recent_commit_count = 10,
        },
        commit_editor = {
          kind = "split",
        },
        log_editor = {
          kind = "split",
        },
        rebase_editor = {
          kind = "split",
        },
        reflog_editor = {
          kind = "split",
        },
        merge_editor = {
          kind = "split",
        },
        tag_editor = {
          kind = "split",
        },
        preview_buffer = {
          kind = "split",
        },
        popup = {
          kind = "split",
        },
        signs = {
          section = { ">", "v" },
          item = { ">", "v" },
          hunk = { ">", "v" },
        },
      })

      -- Keymaps for Neogit operations
      local opts = { noremap = true, silent = true }

      vim.keymap.set("n", "<leader>gg", neogit.open, vim.tbl_extend("force", opts, { desc = "Git status (Neogit)" }))
      vim.keymap.set("n", "<leader>gc", function()
        neogit.open({ "commit" })
      end, vim.tbl_extend("force", opts, { desc = "Git commit" }))
      vim.keymap.set("n", "<leader>gp", function()
        neogit.push_popup()
      end, vim.tbl_extend("force", opts, { desc = "Git push" }))
      vim.keymap.set("n", "<leader>gl", function()
        neogit.pull_popup()
      end, vim.tbl_extend("force", opts, { desc = "Git pull" }))
      vim.keymap.set("n", "<leader>gs", function()
        neogit.stash_popup()
      end, vim.tbl_extend("force", opts, { desc = "Git stash" }))
    end,
  },

  -- ============================================================================
  -- DIFFVIEW: Better diff viewer and git log viewer
  -- ============================================================================
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      local diffview = require("diffview")

      diffview.setup({
        diff_binaries = false,
        enhanced_diff_hl = false,
        git_cmd = { "git" },
        hg_cmd = { "hg" },
        use_icons = true,
        icons = {
          folder_closed = "",
          folder_open = "",
        },
        signs = {
          fold_closed = "",
          fold_open = "",
          done = "✓",
        },
        view = {
          default = {
            layout = "diff2_horizontal",
            winbar_info = false,
          },
          merge_tool = {
            layout = "diff3_horizontal",
            disable_diagnostics = true,
          },
          file_history = {
            layout = "diff2_horizontal",
            winbar_info = false,
          },
        },
        hooks = {},
        keymaps = {
          disable_defaults = false,
          view = {
            { "n", "gf", diffview.goto_file_edit, { desc = "Go to file (edit mode)" } },
            { "n", "<leader>e", diffview.toggle_files, { desc = "Toggle file panel" } },
          },
          file_panel = {
            { "n", "j", diffview.next_file, { desc = "Next file" } },
            { "n", "k", diffview.prev_file, { desc = "Previous file" } },
            { "n", "<leader>e", diffview.toggle_files, { desc = "Toggle file panel" } },
          },
          file_history_panel = {
            { "n", "j", diffview.next_file, { desc = "Next file" } },
            { "n", "k", diffview.prev_file, { desc = "Previous file" } },
            { "n", "<leader>e", diffview.toggle_files, { desc = "Toggle file panel" } },
          },
        },
      })

      -- Keymaps for Diffview
      local opts = { noremap = true, silent = true }

      vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", vim.tbl_extend("force", opts, { desc = "Diff view (open)" }))
      vim.keymap.set("n", "<leader>gD", ":DiffviewClose<CR>", vim.tbl_extend("force", opts, { desc = "Diff view (close)" }))
      vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory<CR>", vim.tbl_extend("force", opts, { desc = "Git history (current file)" }))
    end,
  },
}
