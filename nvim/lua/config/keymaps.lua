-- Keymaps configuration

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- ARROW KEYS: Disabled to enforce hjkl navigation
-- ============================================================================
vim.keymap.set({ 'n', 'i', 'v' }, '<Up>', '<Nop>', { desc = 'Disabled' })
vim.keymap.set({ 'n', 'i', 'v' }, '<Down>', '<Nop>', { desc = 'Disabled' })
vim.keymap.set({ 'n', 'i', 'v' }, '<Left>', '<Nop>', { desc = 'Disabled' })
vim.keymap.set({ 'n', 'i', 'v' }, '<Right>', '<Nop>', { desc = 'Disabled' })

-- ============================================================================
-- NAVIGATION: Window and buffer navigation
-- ============================================================================

-- Window navigation (Ctrl + hjkl) handled by vim-tmux-navigator plugin
-- See: plugins/tmux-navigator.lua for seamless Neovim <-> Tmux navigation

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
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<CR>', { desc = 'Save file (Ctrl+S)' })

-- [B]UFFER OPERATIONS
vim.keymap.set('n', '<leader>bq', function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end
end, { desc = 'Close all buffers except current' })

-- [F]IND/SEARCH (f = find, ff = files, fg = grep, fb = buffers, fd = diagnostics)
-- Telescope keymaps are set in plugins/navigation.lua
-- <leader>ff - Find files
-- <leader>fg - Live grep
-- <leader>fb - Find buffers
-- <leader>fd - Find diagnostics
-- <leader>fc - Find changed files (git)
-- <leader>fh - Help tags

-- [E]XPLORER/TREE (e = explorer)
-- <leader>e defined in plugins/navigation.lua
vim.keymap.set('n', '<leader>eh', function()
  print([[
  NvimTree commands:
    Enter   - Open file/folder
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
  local extensions = {
    -- TypeScript/JavaScript
    'ts', 'tsx', 'js', 'jsx', 'mjs', 'cjs',
    -- Styles
    'css', 'scss', 'sass',
    -- Markup/Data
    'html', 'json', 'yaml', 'yml',
    -- Database/ORM
    'prisma', 'sql', 'graphql', 'gql',
    -- Config
    'env.example', 'env.local.example',
  }
  local ext_flags = table.concat(vim.tbl_map(function(e) return '-e ' .. e end, extensions), ' ')
  local excludes = '--exclude node_modules --exclude .git --exclude coverage --exclude dist --exclude build --exclude .next --exclude .turbo'
  local find_cmd = string.format('fd %s --type f --hidden %s', ext_flags, excludes)
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

-- ============================================================================
-- [S]EARCH SELECTED TEXT (visual mode)
-- ============================================================================

-- Search selected text in project (from current directory)
vim.keymap.set("v", "<leader>sg", function()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  if #lines == 0 then return end

  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
  else
    lines[1] = string.sub(lines[1], start_pos[3])
    lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
  end

  local selected_text = table.concat(lines, "\n")
  selected_text = vim.fn.escape(selected_text, "\\.*[]^$()+?{}")

  require("telescope.builtin").grep_string({ search = selected_text })
end, { desc = "Grep selected text" })

-- Search selected text from git root
vim.keymap.set("v", "<leader>sG", function()
  local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
  local root = vim.v.shell_error == 0 and git_root ~= "" and git_root or vim.fn.getcwd()

  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  if #lines == 0 then return end

  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
  else
    lines[1] = string.sub(lines[1], start_pos[3])
    lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
  end

  local selected_text = table.concat(lines, "\n")
  selected_text = vim.fn.escape(selected_text, "\\.*[]^$()+?{}")

  require("telescope.builtin").grep_string({ search = selected_text, cwd = root })
end, { desc = "Grep selected text (git root)" })

