return {
  "nvim-neotest/neotest",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
    "antoinemadec/FixCursorHold.nvim",
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
    { "<leader>T",  desc = "Test Run" },
    { "<leader>Tn", function() require("neotest").run.run() end, desc = "Run nearest test" },
    {
      "<leader>Tt",
      function() require("neotest").run.run { vim.fn.expand "%" } end,
      desc = "Run all tests",
    },
    { "<leader>Ts", function() require("neotest").summary.toggle() end,      desc = "Neotest summary" },
    { "<leader>To", function() require("neotest").output_panel.toggle() end, desc = "Neotest output pannel" },
  },
}
