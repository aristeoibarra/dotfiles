-- Noice.nvim - Modern UI for cmdline, messages, and notifications
return {
  "folke/noice.nvim",
  lazy = false,
  priority = 900,
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  config = function(_, opts)
    vim.opt.cmdheight = 0 -- Hide cmdline, noice handles it
    require("noice").setup(opts)
  end,
  opts = {
    cmdline = {
      enabled = true,
      view = "cmdline_popup", -- Floating popup for commands
      format = {
        cmdline = { icon = ":" },
        search_down = { icon = "/" },
        search_up = { icon = "?" },
        filter = { icon = "$" },
        lua = { icon = "" },
        help = { icon = "?" },
      },
    },
    messages = {
      enabled = true,
      view = "mini", -- Minimal messages at bottom right
      view_error = "mini",
      view_warn = "mini",
      view_history = "messages",
      view_search = false, -- Disable search count messages
    },
    popupmenu = {
      enabled = true,
      backend = "nui",
    },
    notify = {
      enabled = true,
      view = "mini",
    },
    lsp = {
      progress = {
        enabled = false, -- Disable LSP progress (can be noisy)
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      signature = {
        enabled = false, -- Using lsp_signature or built-in
      },
    },
    presets = {
      bottom_search = false, -- Use floating for search too
      command_palette = true, -- Command palette style
      long_message_to_split = true, -- Long messages in split
      inc_rename = false,
      lsp_doc_border = true,
    },
    views = {
      mini = {
        timeout = 3000,
        position = {
          row = -2,
          col = "100%",
        },
      },
      cmdline_popup = {
        position = {
          row = "50%",
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
        border = {
          style = "rounded",
        },
      },
    },
    routes = {
      -- Hide "written" messages
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true },
      },
      -- Hide search count messages
      {
        filter = {
          event = "msg_show",
          kind = "search_count",
        },
        opts = { skip = true },
      },
      -- Hide "No information available" from LSP
      {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      },
      -- Hide Copilot "rejected by config" messages
      {
        filter = {
          event = "msg_show",
          find = "rejected by config",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "notify",
          find = "rejected by config",
        },
        opts = { skip = true },
      },
    },
  },
}
