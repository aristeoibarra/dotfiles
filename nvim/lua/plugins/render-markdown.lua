-- render-markdown.nvim: Render markdown beautifully in Neovim
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = { "markdown", "obsidian" },
  opts = {
    heading = {
      enabled = true,
      sign = true,
      style = "full",
      icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
      left_pad = 1,
      right_pad = 1,
      backgrounds = {
        "RenderMarkdownH1Bg",
        "RenderMarkdownH2Bg",
        "RenderMarkdownH3Bg",
        "RenderMarkdownH4Bg",
        "RenderMarkdownH5Bg",
        "RenderMarkdownH6Bg",
      },
      foregrounds = {
        "RenderMarkdownH1",
        "RenderMarkdownH2",
        "RenderMarkdownH3",
        "RenderMarkdownH4",
        "RenderMarkdownH5",
        "RenderMarkdownH6",
      },
    },
    bullet = {
      enabled = true,
      icons = { "●", "○", "◆", "◇" },
      right_pad = 1,
    },
    checkbox = {
      enabled = true,
      unchecked = { icon = "☐ " },
      checked = { icon = "✔ " },
      custom = {
        todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
        important = { raw = "[!]", rendered = " ", highlight = "DiagnosticWarn" },
        doing = { raw = "[>]", rendered = " ", highlight = "DiagnosticInfo" },
        cancelled = { raw = "[~]", rendered = "󰰱 ", highlight = "Comment" },
      },
    },
    code = {
      enabled = true,
      sign = false,
      style = "full",
      left_pad = 2,
      right_pad = 2,
      border = "thin",
      language_pad = 1,
    },
    dash = {
      enabled = true,
      icon = "─",
      width = "full",
    },
    link = {
      enabled = true,
      image = "󰥶 ",
      hyperlink = "󰌹 ",
      custom = {
        web = { pattern = "^http[s]?://", icon = "󰖟 " },
        github = { pattern = "github%.com", icon = " " },
        youtube = { pattern = "youtube%.com", icon = "󰗃 " },
      },
    },
    quote = {
      enabled = true,
      icon = "▋",
    },
    pipe_table = {
      enabled = true,
      style = "full",
      cell = "padded",
      border = {
        "┌", "┬", "┐",
        "├", "┼", "┤",
        "└", "┴", "┘",
        "│", "─",
      },
    },
    callout = {
      note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
      tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
      important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
      warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
      caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
    },
    win_options = {
      conceallevel = { rendered = 2 },
    },
  },
  config = function(_, opts)
    require("render-markdown").setup(opts)
  end,
  keys = {
    { "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Render" },
  },
}
