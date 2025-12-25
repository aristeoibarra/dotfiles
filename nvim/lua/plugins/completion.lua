-- Completion: Using blink.cmp (see blink-cmp.lua)
-- This file kept for reference if you ever want to switch back to nvim-cmp
--
-- To switch back to nvim-cmp:
-- 1. Set enabled = true below
-- 2. Set enabled = false in blink-cmp.lua
-- 3. Update lsp.lua to use cmp_nvim_lsp capabilities instead of blink

return {
  {
    "hrsh7th/nvim-cmp",
    enabled = false, -- Using blink.cmp instead
  },
}
