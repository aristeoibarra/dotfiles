-- Integrated terminal - toggleterm.nvim
-- Multi-terminal support with tab-like behavior

-- Helper module for terminal operations
local M = {}

-- Store custom terminal names
M.names = {}

-- Switch to a specific terminal (closes current if open, opens target)
function M.switch_to(target_id)
  local Terminal = require("toggleterm.terminal")
  local current_id = vim.g.toggleterm_last_id
  local dir = vim.g.toggleterm_last_direction or "vertical"

  -- Close current terminal if open and different from target
  if current_id and current_id ~= target_id then
    local current_term = Terminal.get(current_id)
    if current_term and current_term:is_open() then
      current_term:close()
    end
  end

  vim.cmd(target_id .. "ToggleTerm direction=" .. dir)
end

-- Navigate to next/previous terminal (only existing ones)
function M.navigate(direction)
  local Terminal = require("toggleterm.terminal")
  local terms = Terminal.get_all()

  if #terms < 2 then
    vim.notify("Only " .. #terms .. " terminal(s)", vim.log.levels.INFO)
    return
  end

  local current_id = vim.g.toggleterm_last_id or 1
  local dir = vim.g.toggleterm_last_direction or "vertical"

  -- Get sorted list of terminal IDs
  local ids = {}
  for _, t in ipairs(terms) do
    table.insert(ids, t.id)
  end
  table.sort(ids)

  -- Find target ID based on direction
  local target_id
  if direction == "next" then
    target_id = ids[1] -- Default to first (cycle)
    for i, id in ipairs(ids) do
      if id == current_id and ids[i + 1] then
        target_id = ids[i + 1]
        break
      end
    end
  else -- previous
    target_id = ids[#ids] -- Default to last (cycle)
    for i, id in ipairs(ids) do
      if id == current_id and ids[i - 1] then
        target_id = ids[i - 1]
        break
      end
    end
  end

  -- Close current if open
  local current_term = Terminal.get(current_id)
  if current_term and current_term:is_open() then
    current_term:close()
  end

  vim.cmd(target_id .. "ToggleTerm direction=" .. dir)
end

-- Get display name for a terminal
function M.get_name(id)
  return M.names[id] or ("Terminal " .. id)
end

-- Rename current terminal
function M.rename()
  local current_id = vim.g.toggleterm_last_id
  if not current_id then
    vim.notify("No active terminal", vim.log.levels.INFO)
    return
  end

  local current_name = M.names[current_id] or ""
  vim.ui.input({
    prompt = "Terminal " .. current_id .. " name: ",
    default = current_name,
  }, function(name)
    if name == nil then
      return -- Cancelled
    end
    if name == "" then
      M.names[current_id] = nil -- Clear name
    else
      M.names[current_id] = name
    end
  end)
end

-- Terminal selector with custom UI
function M.select()
  local Terminal = require("toggleterm.terminal")
  local terms = Terminal.get_all()

  if #terms == 0 then
    vim.notify("No terminals", vim.log.levels.INFO)
    return
  end

  -- Build list for selector
  local items = {}
  for _, t in ipairs(terms) do
    local display = M.get_name(t.id)
    if t:is_open() then
      display = display .. " (open)"
    end
    table.insert(items, {
      id = t.id,
      display = display,
    })
  end

  vim.ui.select(items, {
    prompt = "Select terminal:",
    format_item = function(item)
      return item.display
    end,
  }, function(choice)
    if not choice then
      return
    end
    M.switch_to(choice.id)
  end)
end


-- Generate keymaps for terminals 1-9
local function generate_terminal_keys()
  local keys = {
    -- Quick toggle (last used terminal)
    { "<C-\\>", "<cmd>ToggleTerm<CR>", mode = { "n", "t" }, desc = "Toggle terminal" },

    -- Navigation
    {
      "<leader>tn",
      function()
        M.navigate("next")
      end,
      mode = { "n", "t" },
      desc = "Next terminal",
    },
    {
      "<leader>tp",
      function()
        M.navigate("prev")
      end,
      mode = { "n", "t" },
      desc = "Previous terminal",
    },

    -- Selector
    {
      "<leader>ts",
      function()
        M.select()
      end,
      desc = "Select terminal",
    },

    -- Rename
    {
      "<leader>tr",
      function()
        M.rename()
      end,
      desc = "Rename terminal",
    },

    -- Direction variants
    { "<leader>th", "<cmd>ToggleTerm direction=horizontal size=15<CR>", desc = "Terminal (horizontal)" },
    { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<CR>", desc = "Terminal (vertical)" },
  }

  -- Generate t1-t9 keymaps dynamically
  for i = 1, 9 do
    table.insert(keys, {
      "<leader>t" .. i,
      function()
        M.switch_to(i)
      end,
      desc = "Terminal " .. i,
    })
  end

  return keys
end

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    lazy = true,
    keys = generate_terminal_keys(),
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = nil,
        hide_numbers = true,
        shade_terminals = false,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        persist_mode = true,
        direction = "vertical",
        close_on_exit = true,
        shell = vim.o.shell,
        auto_scroll = true,

        on_open = function(term)
          -- Set buffer-local options
          vim.opt_local.signcolumn = "no"
          vim.opt_local.foldcolumn = "0"

          -- Store current state globally for navigation
          vim.g.toggleterm_last_direction = term.direction
          vim.g.toggleterm_last_id = term.id

          local opts = { buffer = term.bufnr, silent = true }

          -- Exit terminal mode with Escape
          vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", opts)

          -- Window navigation from terminal
          vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", opts)
          vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", opts)
          vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", opts)
          vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", opts)
        end,
      })
    end,
  },
}
