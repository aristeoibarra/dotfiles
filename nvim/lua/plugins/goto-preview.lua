-- goto-preview: Preview definitions/references in floating window
return {
  "rmagatti/goto-preview",
  event = "BufEnter",
  config = true,
  keys = {
    {
      "gpd",
      "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
      noremap = true,
      desc = "Preview definition",
    },
    {
      "gpD",
      "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>",
      noremap = true,
      desc = "Preview declaration",
    },
    {
      "gpi",
      "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
      noremap = true,
      desc = "Preview implementation",
    },
    {
      "gpy",
      "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
      noremap = true,
      desc = "Preview type definition",
    },
    {
      "gpr",
      "<cmd>lua require('goto-preview').goto_preview_references()<CR>",
      noremap = true,
      desc = "Preview references",
    },
    {
      "gP",
      "<cmd>lua require('goto-preview').close_all_win()<CR>",
      noremap = true,
      desc = "Close all preview windows",
    },
  },
}
