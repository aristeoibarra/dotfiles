-- Snippet engine with modular snippet organization
return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    config = function()
      -- Load snippets from modular files
      require("snippets")
    end,
  },
}
