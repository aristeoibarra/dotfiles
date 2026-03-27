-- Noice.nvim - Modern UI for cmdline, messages, and notifications
return {
  "folke/noice.nvim",
  lazy = false,
  priority = 900,
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  config = function(_, opts)
    vim.opt.cmdheight = 0
    require("noice").setup(opts)
  end,
  opts = {
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
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
      view = "mini",
      view_error = "mini",
      view_warn = "mini",
      view_history = "messages",
      view_search = false,
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
      progress = { enabled = false },
      override = {},
      signature = { enabled = false },
    },
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
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
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          kind = "search_count",
        },
        opts = { skip = true },
      },
    },
  },
}
