-- Harpoon: Quick file bookmarks for fast navigation
-- Using <leader>m (marked files) to avoid conflict with gitsigns (<leader>h)
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
    })

    -- Keymaps using <leader>m (marked files)
    vim.keymap.set("n", "<leader>ma", function()
      harpoon:list():add()
    end, { desc = "Harpoon add file" })

    vim.keymap.set("n", "<leader>mm", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon menu" })

    vim.keymap.set("n", "<leader>mr", function()
      harpoon:list():remove()
    end, { desc = "Harpoon remove file" })

    vim.keymap.set("n", "<leader>mc", function()
      harpoon:list():clear()
    end, { desc = "Harpoon clear all" })

    -- Quick jump to files 1-5
    vim.keymap.set("n", "<leader>1", function()
      harpoon:list():select(1)
    end, { desc = "Harpoon file 1" })

    vim.keymap.set("n", "<leader>2", function()
      harpoon:list():select(2)
    end, { desc = "Harpoon file 2" })

    vim.keymap.set("n", "<leader>3", function()
      harpoon:list():select(3)
    end, { desc = "Harpoon file 3" })

    vim.keymap.set("n", "<leader>4", function()
      harpoon:list():select(4)
    end, { desc = "Harpoon file 4" })

    vim.keymap.set("n", "<leader>5", function()
      harpoon:list():select(5)
    end, { desc = "Harpoon file 5" })

    -- Navigate prev/next
    vim.keymap.set("n", "<leader>mp", function()
      harpoon:list():prev()
    end, { desc = "Harpoon previous" })

    vim.keymap.set("n", "<leader>mn", function()
      harpoon:list():next()
    end, { desc = "Harpoon next" })
  end,
}
