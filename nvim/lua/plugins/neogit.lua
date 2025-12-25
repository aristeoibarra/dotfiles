-- Neogit: Git UI + Diffview
return {
  -- Neogit: Git UI and workflows
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
        commit_editor = { kind = "split" },
        log_editor = { kind = "split" },
        rebase_editor = { kind = "split" },
        reflog_editor = { kind = "split" },
        merge_editor = { kind = "split" },
        tag_editor = { kind = "split" },
        preview_buffer = { kind = "split" },
        popup = { kind = "split" },
        signs = {
          section = { ">", "v" },
          item = { ">", "v" },
          hunk = { ">", "v" },
        },
      })

      -- Keymaps
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

  -- Diffview: Better diff viewer
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      local diffview = require("diffview")

      diffview.setup({
        diff_binaries = false,
        enhanced_diff_hl = false,
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
          default = { layout = "diff2_horizontal", winbar_info = false },
          merge_tool = { layout = "diff3_horizontal", disable_diagnostics = true },
          file_history = { layout = "diff2_horizontal", winbar_info = false },
        },
      })

      -- Keymaps
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", vim.tbl_extend("force", opts, { desc = "Diff view (open)" }))
      vim.keymap.set("n", "<leader>gD", ":DiffviewClose<CR>", vim.tbl_extend("force", opts, { desc = "Diff view (close)" }))
      vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory<CR>", vim.tbl_extend("force", opts, { desc = "Git history" }))
    end,
  },
}
