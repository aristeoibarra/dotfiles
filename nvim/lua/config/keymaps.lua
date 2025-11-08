-- Keymaps configuration

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable arrow keys in all modes to force using hjkl

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

-- Command mode: Allow arrow keys for history navigation (Up/Down) and cursor movement (Left/Right)

-- Better window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to bottom window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to top window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Terminal mode mappings
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Move to left window from terminal' })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = 'Move to bottom window from terminal' })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = 'Move to top window from terminal' })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Move to right window from terminal' })

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right' })

-- Move text up and down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move text down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move text up' })

-- Better paste
vim.keymap.set('v', 'p', '"_dP', { desc = 'Paste without yanking' })

-- Clear highlights
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear highlights' })

-- Save file
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save file' })

-- Quit
vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', { desc = 'Quit' })

-- File explorer help (nvim-tree)
vim.keymap.set('n', '<leader>eh', function()
  print([[
nvim-tree commands:
  <leader>e   - Toggle tree
  <leader>ef  - Find current file in tree

In tree:
  Enter  - Open file/folder
  o      - Open file/folder
  a      - Create file/folder
  r      - Rename
  d      - Delete
  x      - Cut
  c      - Copy
  p      - Paste
  R      - Refresh
  H      - Toggle hidden files
  ]])
end, { desc = 'nvim-tree help' })

-- Splits
vim.keymap.set('n', '<leader>sh', '<cmd>split<CR>', { desc = 'Horizontal split' })
vim.keymap.set('n', '<leader>sv', '<cmd>vsplit<CR>', { desc = 'Vertical split' })

-- Resize windows quickly (Space + r + hjkl)
vim.keymap.set('n', '<leader>rh', '<cmd>vertical resize -5<CR>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<leader>rl', '<cmd>vertical resize +5<CR>', { desc = 'Increase window width' })
vim.keymap.set('n', '<leader>rj', '<cmd>resize -3<CR>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<leader>rk', '<cmd>resize +3<CR>', { desc = 'Increase window height' })

-- Toggle line numbers
vim.keymap.set('n', '<leader>tn', function()
  if vim.o.number then
    vim.o.number = false
    print('Line numbers: OFF')
  else
    vim.o.number = true
    print('Line numbers: ON')
  end
end, { desc = 'Toggle line numbers' })

-- Toggle mouse support
vim.keymap.set('n', '<leader>tm', function()
  if vim.o.mouse == 'a' then
    vim.o.mouse = ''
    print('Mouse: OFF')
  else
    vim.o.mouse = 'a'
    print('Mouse: ON')
  end
end, { desc = 'Toggle mouse' })

vim.keymap.set('n', '<leader><leader>', '<C-^>', { desc = 'Toggle last buffer' })

-- Diagnostics
vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist, { desc = 'Show diagnostics list (current file)' })
vim.keymap.set('n', '<leader>da', vim.diagnostic.setqflist, { desc = 'All diagnostics (project)' })
vim.keymap.set('n', '<leader>D', vim.diagnostic.open_float, { desc = 'Show diagnostic details' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })

-- Load all project files for full LSP scan (on-demand)
vim.keymap.set('n', '<leader>la', function()
  print('Loading all project files...')

  -- Find all relevant files (respects .gitignore)
  -- Includes: TS, TSX, JS, JSX, HTML, CSS, JSON, Prisma
  local files = vim.fn.systemlist(
    'rg --files -g "*.{ts,tsx,js,jsx,html,css,scss,json,prisma}" 2>/dev/null'
  )

  if #files == 0 then
    print('No files found')
    return
  end

  print(string.format('Found %d files. Loading in batches...', #files))

  -- Load files in batches to avoid "too many open files" error
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
      -- Schedule next batch
      vim.defer_fn(function()
        load_batch(end_idx + 1)
      end, 100)
    else
      -- All done
      vim.defer_fn(function()
        print(string.format('Loaded %d/%d files. LSP scanning complete. Use <leader>fd', loaded, total))
      end, 1000)
    end
  end

  -- Start loading
  load_batch(1)
end, { desc = 'Load all project files (scan)' })

-- Cheatsheet: Show all keybindings interactively with Telescope
vim.keymap.set('n', '<leader>?', function()
  require('telescope.builtin').keymaps({
    prompt_title = 'Cheatsheet - Todos los Keybindings',
    layout_config = {
      height = 0.9,
      width = 0.9,
    },
  })
end, { desc = 'Cheatsheet (all keybindings)' })

-- Vim Cheatsheet: Native Vim commands for programmers
vim.keymap.set('n', '<leader>ch', function()
  require('config.vim-cheatsheet').toggle()
end, { desc = 'Vim Cheatsheet (native commands)' })
