-- Keymaps configuration

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- DISABLED KEYS: Disable arrow keys to force hjkl
-- ============================================================================

-- Normal mode
vim.keymap.set('n', '<Up>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('n', '<Down>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('n', '<Left>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('n', '<Right>', '<Nop>', { noremap = true, silent = true })

-- Insert mode
vim.keymap.set('i', '<Up>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('i', '<Down>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('i', '<Left>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('i', '<Right>', '<Nop>', { noremap = true, silent = true })

-- Visual mode
vim.keymap.set('v', '<Up>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('v', '<Down>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('v', '<Left>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('v', '<Right>', '<Nop>', { noremap = true, silent = true })

-- ============================================================================
-- NAVIGATION: Window and buffer navigation
-- ============================================================================

-- Window navigation (Ctrl + hjkl)
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to bottom window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to top window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Terminal keymaps are defined in plugins/terminal.lua

-- Buffer switching
vim.keymap.set('n', '<leader><leader>', '<C-^>', { desc = 'Toggle last buffer' })

-- ============================================================================
-- EDITING: Text manipulation in visual mode
-- ============================================================================

-- Indentation
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right' })

-- Move text up/down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move text down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move text up' })

-- Paste without yanking
vim.keymap.set('v', 'p', '"_dP', { desc = 'Paste without copying' })

-- ============================================================================
-- GENERAL: Basic commands
-- ============================================================================

-- Clear search highlights
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear highlights' })

-- ============================================================================
-- LEADER KEYMAPS (Organized by function with consistent mnemonics)
-- ============================================================================

-- [F]ILE OPERATIONS (f = file, w = write, q = quit)
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save file (write)' })
vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', { desc = 'Quit editor' })

-- [F]IND/SEARCH (f = find, ff = files, fg = grep, fb = buffers, fd = diagnostics)
-- Telescope keymaps are set in plugins/navigation.lua
-- <leader>ff - Find files
-- <leader>fg - Live grep
-- <leader>fb - Find buffers
-- <leader>fd - Find diagnostics
-- <leader>fc - Find changed files (git)
-- <leader>fh - Help tags

-- [E]XPLORER/TREE (e = explorer)
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
vim.keymap.set('n', '<leader>eh', function()
  print([[
  nvim-tree in-tree commands:
    Enter   - Open file/folder
    o       - Open file/folder
    a       - Create file/folder
    r       - Rename
    d       - Delete
    x       - Cut
    c       - Copy
    p       - Paste
    R       - Refresh
    H       - Toggle hidden files
  ]])
end, { desc = 'Show file explorer help' })

-- [S]PLITS & WINDOWS (s = split, r = resize)
vim.keymap.set('n', '<leader>sh', '<cmd>split<CR>', { desc = 'Horizontal split' })
vim.keymap.set('n', '<leader>sv', '<cmd>vsplit<CR>', { desc = 'Vertical split' })

-- [R]ESIZE WINDOWS (r = resize, h/l = width, j/k = height)
vim.keymap.set('n', '<leader>rh', '<cmd>vertical resize -5<CR>', { desc = 'Decrease width' })
vim.keymap.set('n', '<leader>rl', '<cmd>vertical resize +5<CR>', { desc = 'Increase width' })
vim.keymap.set('n', '<leader>rj', '<cmd>resize -3<CR>', { desc = 'Decrease height' })
vim.keymap.set('n', '<leader>rk', '<cmd>resize +3<CR>', { desc = 'Increase height' })

-- [U]I TOGGLES (u = ui)
vim.keymap.set('n', '<leader>un', function()
  if not vim.o.number and not vim.o.relativenumber then
    vim.o.number = true
    vim.o.relativenumber = true
    print('Line numbers: RELATIVE')
  elseif vim.o.number and vim.o.relativenumber then
    vim.o.number = true
    vim.o.relativenumber = false
    print('Line numbers: NORMAL')
  else
    vim.o.number = false
    vim.o.relativenumber = false
    print('Line numbers: OFF')
  end
end, { desc = 'Toggle line numbers (cycle)' })

vim.keymap.set('n', '<leader>um', function()
  if vim.o.mouse == 'a' then
    vim.o.mouse = ''
    print('Mouse: OFF')
  else
    vim.o.mouse = 'a'
    print('Mouse: ON')
  end
end, { desc = 'Toggle mouse support' })

vim.keymap.set('n', '<leader>uw', function()
  vim.o.wrap = not vim.o.wrap
end, { desc = 'Toggle line wrap (for Tailwind)' })

-- [D]IAGNOSTICS (d = diagnostics)
vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist, { desc = 'Diagnostics list (buffer)' })
vim.keymap.set('n', '<leader>D', vim.diagnostic.open_float, { desc = 'Diagnostic details (float)' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })

-- [C]ODE & LSP (c = code: cr = rename, ca = actions, cf = format, li = lsp info)
-- Note: Most LSP keymaps are set in plugins/lsp.lua
-- <leader>cr - Code rename
-- <leader>ca - Code actions
-- <leader>cf - Code format
-- <leader>li - LSP info

vim.keymap.set('n', '<leader>la', function()
  print('Loading all project files...')
  local find_cmd = "fd -e ts -e tsx -e js -e jsx -e html -e css -e scss -e json -e prisma --type f --hidden --exclude node_modules --exclude .git --exclude coverage --exclude dist --exclude build"
  local files = vim.fn.systemlist(find_cmd)

  if #files == 0 then
    print('No files found')
    return
  end

  print(string.format('Found %d files. Loading in batches...', #files))

  local batch_size = 50
  local total = #files
  local loaded = 0

  local function load_batch(start_idx)
    local end_idx = math.min(start_idx + batch_size - 1, total)
    for i = start_idx, end_idx do
      local bufnr = vim.fn.bufadd(files[i])
      if bufnr > 0 then
        vim.fn.bufload(bufnr)
        loaded = loaded + 1
      end
    end

    if end_idx < total then
      vim.defer_fn(function()
        load_batch(end_idx + 1)
      end, 100)
    else
      vim.defer_fn(function()
        print(string.format('Loaded %d/%d files. LSP scanning complete.', loaded, total))
      end, 1000)
    end
  end

  load_batch(1)
end, { desc = 'Load all project files (LSP scan)' })

-- [G]IT (g = git)
-- <leader>gg - Git status (Neogit)
-- <leader>gc - Git commit
-- <leader>gp - Git push
-- <leader>gl - Git pull
-- <leader>gs - Git stash
-- <leader>gd - Diffview open
-- <leader>gD - Diffview close
-- <leader>gh - Git history
-- <leader>hp - Preview hunk
-- <leader>hs - Stage hunk
-- <leader>hu - Undo hunk
-- <leader>hr - Reset hunk
-- <leader>hb - Blame line
-- <leader>hd - Diff hunk
-- ]h / [h - Next/previous hunk

-- [H]ELP & REFERENCE (? = help, ch = cheatsheet)
vim.keymap.set('n', '<leader>?', function()
  require('telescope.builtin').keymaps({
    prompt_title = 'Cheatsheet - All Keybindings',
    layout_config = {
      height = 0.9,
      width = 0.9,
    },
  })
end, { desc = 'Show all keybindings' })

vim.keymap.set('n', '<leader>ch', function()
  require('config.vim-cheatsheet').toggle()
end, { desc = 'Vim cheatsheet (native commands)' })

