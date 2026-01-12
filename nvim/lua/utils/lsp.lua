-- LSP Utilities - Fallbacks, logging, and helpers
local M = {}

-- ============================================================================
-- LOGGING
-- ============================================================================

local function log_message(level, message)
  local prefix = string.format("[LSP %s]", level)
  vim.notify(prefix .. " " .. message, vim.log.levels[level])
end

function M.log_info(msg)
  log_message("INFO", msg)
end

function M.log_warn(msg)
  log_message("WARN", msg)
end

function M.log_error(msg)
  log_message("ERROR", msg)
end

function M.log_debug(msg)
  local debug_enabled = os.getenv("NVIM_LSP_DEBUG") == "1"
  if debug_enabled then
    log_message("DEBUG", msg)
  end
end

-- ============================================================================
-- SERVER MANAGEMENT
-- ============================================================================

-- Check if LSP server is installed
function M.is_server_installed(server_name)
  local mason_registry = require("mason-registry")
  local ok, package = pcall(function()
    return mason_registry.get_package(server_name)
  end)

  if not ok then
    M.log_debug("Mason registry error for " .. server_name)
    return false
  end

  return package:is_installed()
end

-- Get list of active LSP clients
function M.get_active_clients()
  local clients = vim.lsp.get_clients()
  local client_list = {}

  for _, client in ipairs(clients) do
    table.insert(client_list, {
      name = client.name,
      id = client.id,
      attached_buffers = #vim.tbl_keys(client.attached_buffers),
    })
  end

  return client_list
end

-- Log status of all LSP servers
function M.log_lsp_status()
  local clients = M.get_active_clients()

  if #clients == 0 then
    M.log_warn("No active LSP clients")
    return
  end

  vim.notify("\n=== ACTIVE LSP SERVERS ===\n", vim.log.levels.INFO)
  for _, client in ipairs(clients) do
    local info = string.format(
      "• %s (ID: %d, Buffers: %d)",
      client.name,
      client.id,
      client.attached_buffers
    )
    vim.notify(info, vim.log.levels.INFO)
  end
  vim.notify("\n", vim.log.levels.INFO)
end

-- ============================================================================
-- KEYMAPS
-- ============================================================================

-- Setup LSP keymaps for a buffer
function M.setup_keymaps(bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }

  local keymaps = {
    -- Navigation
    { "n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" } },
    { "n", "gv", function()
      vim.cmd("vsplit")
      vim.lsp.buf.definition()
    end, { desc = "Definition in vsplit" } },
    { "n", "gs", function()
      vim.cmd("split")
      vim.lsp.buf.definition()
    end, { desc = "Definition in split" } },
    { "n", "gr", vim.lsp.buf.references, { desc = "Go to references" } },
    { "n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" } },

    -- Info
    { "n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" } },

    -- Refactoring
    { "n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" } },
    { "n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" } },
    -- NOTE: <leader>cf is handled by conform.nvim in formatting.lua
  }

  for _, keymap in ipairs(keymaps) do
    local mode, key, func, desc = keymap[1], keymap[2], keymap[3], keymap[4]
    vim.keymap.set(mode, key, func, vim.tbl_extend("force", opts, desc))
  end
end

-- ============================================================================
-- DIAGNOSTICS
-- ============================================================================

-- Configure diagnostic display
function M.setup_diagnostics()
  vim.diagnostic.config({
    virtual_text = {
      prefix = "",
      spacing = 4,
      source = "if_many",
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "E",
        [vim.diagnostic.severity.WARN] = "W",
        [vim.diagnostic.severity.HINT] = "H",
        [vim.diagnostic.severity.INFO] = "I",
      },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })
end

return M
