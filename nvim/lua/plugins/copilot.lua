-- GitHub Copilot AI Assistant
return {
  -- Official GitHub Copilot plugin (inline suggestions)
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      -- Enable Copilot for all filetypes except Claude Code terminal
      vim.g.copilot_filetypes = {
        ["*"] = true,
        claudecode = false,  -- Disable in Claude Code terminal to avoid interference
      }

      -- Disable default Tab mapping to avoid conflicts
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true

      -- Custom keymaps for better control
      vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        desc = "Accept Copilot suggestion",
      })
      vim.keymap.set("i", "<M-]>", "<Plug>(copilot-next)", { desc = "Next Copilot suggestion" })
      vim.keymap.set("i", "<M-[>", "<Plug>(copilot-previous)", { desc = "Previous Copilot suggestion" })
      vim.keymap.set("i", "<C-x>", "<Plug>(copilot-dismiss)", { desc = "Dismiss Copilot" })
    end,
  },
}
