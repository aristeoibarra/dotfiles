-- DAP: Debug Adapter Protocol for debugging in Neovim
return {
  -- nvim-dap: Core debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- DAP UI
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      -- Virtual text for variables
      "theHamsta/nvim-dap-virtual-text",
      -- Mason integration for installing debug adapters
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dr", function() require("dap").restart() end, desc = "Restart" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
      { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Hover Variables" },
      { "<leader>ds", function() require("dap.ui.widgets").scopes() end, desc = "Scopes" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Mason DAP setup (auto-install debug adapters)
      require("mason-nvim-dap").setup({
        ensure_installed = { "js-debug-adapter" },
        automatic_installation = true,
        handlers = {},
      })

      -- DAP UI setup
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
        },
        floating = {
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
      })

      -- Virtual text setup
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        virt_text_pos = "eol",
      })

      -- Auto open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Breakpoint signs
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })

      -- =======================================================================
      -- KANAGAWA DRAGON COLORS
      -- =======================================================================
      -- Red: #c4746e | Green: #8a9a7b | Yellow: #c4b28a | Blue: #8ba4b0
      -- Bright Blue: #7fb4ca | Magenta: #938aa9 | Cyan: #7aa89f
      -- =======================================================================
      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#c4746e" })           -- Red
      vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#c4b28a" })  -- Yellow
      vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#7fb4ca" })             -- Bright Blue
      vim.api.nvim_set_hl(0, "DapStopped", { fg = "#8a9a7b" })              -- Green
      vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#1f1d1a" })          -- Subtle yellow tint

      -- =====================================================================
      -- JavaScript/TypeScript/Node.js Configuration
      -- =====================================================================

      -- Use js-debug-adapter (vscode-js-debug)
      local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug_path .. "/js-debug/src/dapDebugServer.js", "${port}" },
        },
      }

      -- Configurations for JavaScript/TypeScript
      local js_config = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file (ts-node)",
          program = "${file}",
          cwd = "${workspaceFolder}",
          runtimeExecutable = "ts-node",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "node_modules/**" },
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to process",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug Jest Tests",
          runtimeExecutable = "node",
          runtimeArgs = {
            "./node_modules/jest/bin/jest.js",
            "--runInBand",
          },
          rootPath = "${workspaceFolder}",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
          sourceMaps = true,
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug npm script",
          cwd = "${workspaceFolder}",
          runtimeExecutable = "npm",
          runtimeArgs = { "run-script", "dev" },
          sourceMaps = true,
        },
      }

      dap.configurations.javascript = js_config
      dap.configurations.typescript = js_config
      dap.configurations.javascriptreact = js_config
      dap.configurations.typescriptreact = js_config
    end,
  },
}
