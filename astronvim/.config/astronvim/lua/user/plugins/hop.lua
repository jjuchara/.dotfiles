local prefix = "<leader>s"
return {
  "phaazon/hop.nvim",
  keys = {
    { prefix,        desc = "Hop" },
    { prefix .. "s", "<cmd>HopChar2<CR>", desc = "Hop char" },
    { prefix .. "w", "<cmd>HopWord<CR>",  desc = "Hop word" },
  },
  branch = "v2",
  config = function() require("hop").setup { keys = "etovxqpdygfblzhckisuran" } end,
}
