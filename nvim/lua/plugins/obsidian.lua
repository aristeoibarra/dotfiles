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
    daily_notes = {
      folder = "daily",
      date_format = "%Y-%m-%d",
      template = "template-daily.md",
    },
    templates = {
      folder = "",
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
    legacy_commands = false,
    -- Disable automatic frontmatter
    frontmatter = {
      enabled = false,
    },
  },
  init = function()
    vim.opt.conceallevel = 2
  end,
  keys = {
    -- Using <leader>O to avoid conflict with OpenCode (<leader>o)
    { "<leader>Of", "<cmd>Obsidian quick_switch<cr>", desc = "Obsidian: Find notes" },
    { "<leader>Os", "<cmd>Obsidian search<cr>", desc = "Obsidian: Search vault" },
    { "<leader>On", "<cmd>Obsidian new<cr>", desc = "Obsidian: New note" },
    { "<leader>Ow", "<cmd>Obsidian workspace<cr>", desc = "Obsidian: Switch workspace" },
    { "<leader>Ol", "<cmd>Obsidian links<cr>", desc = "Obsidian: Show links" },
    { "<leader>Ob", "<cmd>Obsidian backlinks<cr>", desc = "Obsidian: Show backlinks" },
    { "<leader>Or", "<cmd>Obsidian rename<cr>", desc = "Obsidian: Rename note" },
    { "<leader>Oc", "<cmd>Obsidian toggle_checkbox<cr>", desc = "Obsidian: Toggle checkbox", ft = "markdown" },
    { "gf", "<cmd>Obsidian follow_link<cr>", desc = "Obsidian: Follow link", ft = "markdown" },
  },
}
