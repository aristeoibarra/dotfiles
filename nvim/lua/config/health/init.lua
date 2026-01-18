-- Custom health checks for nvim config
local M = {}

local health = vim.health

function M.check()
  health.start("Mason LSP Servers")

  -- Check if Mason bin directory exists
  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
  if vim.fn.isdirectory(mason_bin) == 0 then
    health.error("Mason bin directory not found", { "Run :Mason and install required servers" })
    return
  end

  -- Required LSP servers
  local required_servers = {
    "typescript-language-server",
    "tailwindcss-language-server",
    "vscode-css-language-server",
    "vscode-html-language-server",
    "vscode-json-language-server",
  }

  for _, server in ipairs(required_servers) do
    local server_path = mason_bin .. "/" .. server
    if vim.fn.executable(server_path) == 1 then
      health.ok(server .. " installed and executable")
    else
      health.error(server .. " not working", {
        "Try: :MasonInstall " .. server:gsub("vscode%-", ""):gsub("%-language%-server", "-lsp"),
        "Or run: cd ~/.local/share/nvim/mason/packages/" .. server .. " && npm install",
      })
    end
  end

  health.start("npm Configuration")

  -- Check npm registry
  local npm_registry = vim.fn.system("npm config get registry"):gsub("\n", "")
  if npm_registry:match("^https://") then
    health.ok("npm registry using HTTPS: " .. npm_registry)
  else
    health.error("npm registry NOT using HTTPS: " .. npm_registry, {
      "Run: npm config set registry https://registry.npmjs.org/",
    })
  end
end

return M
