return {
  {
    "0x100101/lab.nvim",
    build = "cd js && npm ci",
    config = function()
      require("lab").setup({
        code_runner = {
          enabled = true,
        },
        quick_data = {
          enabled = true,
        },
      })
    end,
    keys = {
      { "<M-4>", "<cmd>Lab code run<cr>", desc = "Run code" },
      { "<M-5>", "<cmd>Lab code stop<cr>", desc = "Stop code" },
      { "<m-6>", "<cmd>Lab code panel<cr>", desc = "Code pannel" },
    },
  },
}
