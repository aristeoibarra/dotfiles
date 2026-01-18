-- rip-substitute: Search and replace with ripgrep
return {
  "chrisgrieser/nvim-rip-substitute",
  cmd = "RipSubstitute",
  keys = {
    {
      "<leader>fs",
      function()
        require("rip-substitute").sub()
      end,
      mode = { "n", "x" },
      desc = "Find & substitute (ripgrep)",
    },
  },
}
