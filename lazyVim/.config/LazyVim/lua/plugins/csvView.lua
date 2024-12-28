return {
  {
    "hat0uma/csvview.nvim",
    config = function()
      require("csvview").setup({
        delimiter = ";",
      })
    end,
  },
}
