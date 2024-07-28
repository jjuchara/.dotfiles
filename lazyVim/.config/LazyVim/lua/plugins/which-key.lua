return {
  "folke/which-key.nvim",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    defaults = {
      ["<leader>n"] = { name = "+Notes" },
      ["<leader>a"] = { name = "+Ai" },
    },
  },
}
