return {
  "folke/which-key.nvim",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    spec = {
      { "<leader>a", group = "+Ai" },
    },
  },
}
