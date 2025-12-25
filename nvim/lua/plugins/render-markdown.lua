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

    -- =======================================================================
    -- KANAGAWA DRAGON COLORS
    -- =======================================================================
    -- Red: #c4746e | Green: #8a9a7b | Yellow: #c4b28a | Blue: #8ba4b0
    -- Bright Blue: #7fb4ca | Magenta: #938aa9 | Cyan: #7aa89f
    -- Background: #181616
    -- =======================================================================

    -- Heading foregrounds (using Kanagawa Dragon palette)
    vim.api.nvim_set_hl(0, "RenderMarkdownH1", { fg = "#c4746e", bold = true })  -- Red
    vim.api.nvim_set_hl(0, "RenderMarkdownH2", { fg = "#c4b28a", bold = true })  -- Yellow
    vim.api.nvim_set_hl(0, "RenderMarkdownH3", { fg = "#8a9a7b", bold = true })  -- Green
    vim.api.nvim_set_hl(0, "RenderMarkdownH4", { fg = "#7fb4ca", bold = true })  -- Bright Blue
    vim.api.nvim_set_hl(0, "RenderMarkdownH5", { fg = "#938aa9", bold = true })  -- Magenta
    vim.api.nvim_set_hl(0, "RenderMarkdownH6", { fg = "#7aa89f", bold = true })  -- Cyan

    -- Heading backgrounds (subtle tints based on Kanagawa Dragon)
    vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = "#1f1a1a" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = "#1f1d1a" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = "#1a1d1a" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = "#1a1c1f" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { bg = "#1c1a1d" })
    vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { bg = "#1a1c1c" })

    -- Other elements
    vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = "#7fb4ca" })   -- Bright Blue
    vim.api.nvim_set_hl(0, "RenderMarkdownTodo", { fg = "#c4b28a" })     -- Yellow
    vim.api.nvim_set_hl(0, "RenderMarkdownInfo", { fg = "#7fb4ca" })     -- Bright Blue
    vim.api.nvim_set_hl(0, "RenderMarkdownSuccess", { fg = "#8a9a7b" })  -- Green
    vim.api.nvim_set_hl(0, "RenderMarkdownHint", { fg = "#938aa9" })     -- Magenta
    vim.api.nvim_set_hl(0, "RenderMarkdownWarn", { fg = "#c4b28a" })     -- Yellow
    vim.api.nvim_set_hl(0, "RenderMarkdownError", { fg = "#c4746e" })    -- Red
  end,
  keys = {
    { "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Render" },
  },
}
