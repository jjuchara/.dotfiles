return {
  "nvim-neotest/neotest",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
  },
  init = function()
    require("neotest").setup {
      adapters = {
        require "neotest-python" {
          dap = { justMyCode = false },
          runner = "pytest",
        },
      },
    }
  end,
  keys = {
    { "<leader>Tn", function() require("neotest").run.run() end },
  },
}
