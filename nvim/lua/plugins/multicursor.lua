-- Multicursor: Edit multiple places simultaneously
-- Using <leader>M (capital) to avoid conflict with Harpoon (<leader>m)
return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  config = function()
    local mc = require("multicursor-nvim")

    mc.setup()

    local map = vim.keymap.set

    -- Add cursors above/below the main cursor
    map({ "n", "v" }, "<up>", function() mc.lineAddCursor(-1) end, { desc = "Add cursor above" })
    map({ "n", "v" }, "<down>", function() mc.lineAddCursor(1) end, { desc = "Add cursor below" })

    -- Add a cursor and jump to the next word under cursor
    map({ "n", "v" }, "<C-n>", function() mc.matchAddCursor(1) end, { desc = "Add cursor to next match" })

    -- Jump to the next word under cursor but do not add a cursor
    map({ "n", "v" }, "<C-s>", function() mc.matchSkipCursor(1) end, { desc = "Skip to next match" })

    -- Add a cursor and jump to the previous word under cursor
    map({ "n", "v" }, "<C-S-n>", function() mc.matchAddCursor(-1) end, { desc = "Add cursor to prev match" })

    -- Add all matches in the document
    map({ "n", "v" }, "<leader>Ma", function() mc.matchAllAddCursors() end, { desc = "Multicursor: all matches" })

    -- Rotate the main cursor
    map({ "n", "v" }, "<left>", mc.prevCursor, { desc = "Prev cursor" })
    map({ "n", "v" }, "<right>", mc.nextCursor, { desc = "Next cursor" })

    -- Delete the main cursor
    map({ "n", "v" }, "<leader>Mx", mc.deleteCursor, { desc = "Multicursor: delete" })

    -- Add and remove cursors with control + left click
    map("n", "<c-leftmouse>", mc.handleMouse, { desc = "Add cursor with mouse" })

    -- Easy way to add and remove cursors using the main cursor
    map({ "n", "v" }, "<c-q>", mc.toggleCursor, { desc = "Toggle cursor" })

    -- Clone every cursor and disable the originals
    map({ "n", "v" }, "<leader>Md", mc.duplicateCursors, { desc = "Multicursor: duplicate" })

    -- Escape to clear cursors
    map("n", "<esc>", function()
      if not mc.cursorsEnabled() then
        mc.enableCursors()
      elseif mc.hasCursors() then
        mc.clearCursors()
      else
        -- Default <esc> handler
        vim.cmd("noh")
      end
    end, { desc = "Clear cursors / nohlsearch" })

    -- Align cursor columns
    map("n", "<leader>MA", mc.alignCursors, { desc = "Multicursor: align" })

    -- Split visual selections by regex
    map("v", "<leader>Ms", mc.splitCursors, { desc = "Multicursor: split by regex" })

    -- Append/insert for each line of visual selections
    map("v", "I", mc.insertVisual, { desc = "Insert at visual" })
    map("v", "A", mc.appendVisual, { desc = "Append at visual" })

    -- Match new cursors within visual selections by regex
    map("v", "M", mc.matchCursors, { desc = "Match cursors by regex" })

    -- Rotate visual selection contents
    map("v", "<leader>Mt", function() mc.transposeCursors(1) end, { desc = "Multicursor: transpose next" })
    map("v", "<leader>MT", function() mc.transposeCursors(-1) end, { desc = "Multicursor: transpose prev" })

    -- Customize how cursors look
    local hl = vim.api.nvim_set_hl
    hl(0, "MultiCursorCursor", { link = "Cursor" })
    hl(0, "MultiCursorVisual", { link = "Visual" })
    hl(0, "MultiCursorSign", { link = "SignColumn" })
    hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
    hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
  end,
}
