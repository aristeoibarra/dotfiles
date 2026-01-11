-- Obsidian.nvim - Neovim plugin for Obsidian note-taking
return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "aristeo",
        path = vim.fn.expand("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/aristeo"),
      },
      {
        name = "docs",
        path = vim.fn.expand("~/digiin/docs"),
      },
    },
    ui = {
      enable = false, -- Use render-markdown.nvim instead
    },
    picker = {
      name = "telescope.nvim",
    },
    completion = {
      nvim_cmp = false, -- Using blink.cmp
      min_chars = 2,
    },
    -- Callbacks for keymaps inside notes
    callbacks = {
      enter_note = function(client, note)
        -- Follow link under cursor
        vim.keymap.set("n", "gf", function()
          return require("obsidian").util.gf_passthrough()
        end, { buffer = note.bufnr, expr = true, desc = "Obsidian follow link" })

        -- Toggle checkbox
        vim.keymap.set("n", "<leader>Oc", function()
          return require("obsidian").util.toggle_checkbox()
        end, { buffer = note.bufnr, desc = "Toggle checkbox" })

        -- Smart action (follow link or toggle checkbox)
        vim.keymap.set("n", "<CR>", function()
          return require("obsidian").util.smart_action()
        end, { buffer = note.bufnr, expr = true, desc = "Obsidian smart action" })
      end,
    },
    -- Templates configuration
    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      substitutions = {
        yesterday = function()
          return os.date("%Y-%m-%d", os.time() - 86400)
        end,
        tomorrow = function()
          return os.date("%Y-%m-%d", os.time() + 86400)
        end,
      },
    },
    -- Daily notes
    daily_notes = {
      folder = "daily",
      date_format = "%Y-%m-%d",
      template = nil,
    },
    -- Note naming
    note_id_func = function(title)
      local suffix = ""
      if title ~= nil then
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        suffix = tostring(os.time())
      end
      return suffix
    end,
    legacy_commands = true,
  },
  init = function()
    vim.opt.conceallevel = 2
  end,
  keys = {
    -- Using <leader>O to avoid conflict with OpenCode (<leader>o)
    { "<leader>Of", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian: Find notes" },
    { "<leader>Os", "<cmd>ObsidianSearch<cr>", desc = "Obsidian: Search vault" },
    { "<leader>On", "<cmd>ObsidianNew<cr>", desc = "Obsidian: New note" },
    { "<leader>Ow", "<cmd>ObsidianWorkspace<cr>", desc = "Obsidian: Switch workspace" },
    { "<leader>Od", "<cmd>ObsidianToday<cr>", desc = "Obsidian: Daily note" },
    { "<leader>Oy", "<cmd>ObsidianYesterday<cr>", desc = "Obsidian: Yesterday note" },
    { "<leader>Ot", "<cmd>ObsidianTemplate<cr>", desc = "Obsidian: Insert template" },
    { "<leader>Ol", "<cmd>ObsidianLinks<cr>", desc = "Obsidian: Show links" },
    { "<leader>Ob", "<cmd>ObsidianBacklinks<cr>", desc = "Obsidian: Show backlinks" },
    { "<leader>Or", "<cmd>ObsidianRename<cr>", desc = "Obsidian: Rename note" },
  },
}
