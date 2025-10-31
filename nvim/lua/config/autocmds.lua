-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
  desc = "Highlight when yanking text",
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  group = augroup("trim_whitespace", { clear = true }),
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
  desc = "Remove trailing whitespace on save",
})

-- Close certain filetypes with <q>
autocmd("FileType", {
  group = augroup("close_with_q", { clear = true }),
  pattern = {
    "help",
    "lspinfo",
    "man",
    "qf",
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
  desc = "Close certain filetypes with q",
})

-- Better wrap for text files (Markdown, etc)
autocmd("FileType", {
  group = augroup("text_wrap", { clear = true }),
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.linebreak = true  -- Break at word boundaries
    vim.opt_local.breakindent = true  -- Maintain indentation when wrapping
  end,
  desc = "Better wrapping for text files",
})

-- Open images with external application (ultra minimal)
autocmd("BufReadPre", {
  group = augroup("open_images_externally", { clear = true }),
  pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.bmp", "*.webp", "*.svg", "*.ico" },
  callback = function(event)
    vim.schedule(function()
      -- Open with system default app
      vim.fn.jobstart({ "open", event.file }, { detach = true })

      -- Close the buffer and show message
      vim.cmd("bdelete!")

      -- Show clean message
      local filename = vim.fn.fnamemodify(event.file, ":t")
      print("Opened image: " .. filename)
    end)
  end,
  desc = "Open images with system default app",
})
