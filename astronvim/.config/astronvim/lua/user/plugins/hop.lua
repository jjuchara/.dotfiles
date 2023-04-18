local prefix = "f"
local keymap = vim.api.nvim_set_keymap
return {
  "phaazon/hop.nvim",
  event = "BufRead",
  keys = {
    { prefix, desc = "Hop" },
    { prefix .. "w", "<cmd>HopWord<CR>", desc = "Hop word" },
    { prefix .. "p", "<cmd>HopPattern<CR>", desc = "Hop pattern and go to it" },
    { prefix .. "l", "<cmd>HopLineStart<CR>", desc = "Hop line" },
    { prefix .. "c", "<cmd>HopChar1<CR>", desc = "Hop Char1" },
  },
  branch = "v2",
  config = function()
    require("hop").setup {
      keys = "etovxqpdygfblzhckisuran",
      vim.api.nvim_set_keymap("o", "S", ":HopChar1<cr>", { silent = true }),
    }
  end,
}
--
