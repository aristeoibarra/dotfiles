-- Claude Code: MCP bridge for external Claude Code CLI
return {
  "coder/claudecode.nvim",
  event = "VeryLazy",
  opts = {
    terminal = {
      provider = "none",
    },
  },
}
