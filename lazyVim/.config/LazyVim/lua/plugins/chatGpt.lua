return {
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("chatgpt").setup({
        openai_params = {
          model = "gpt-4o",
          frequency_penalty = 0,
          presence_penalty = 0,
          max_tokens = 4096,
          temperature = 0,
          top_p = 1,
          n = 1,
        },
      })
    end,
    keys = {
      { "<leader>ac", "<cmd>ChatGPT<cr>", desc = "run CHatGPT" },
      { "<leader>ae", "<cmd>ChatGPTActAs<cr>", desc = "act as GPT" },
      {
        "<leader>ar",
        "<cmd>ChatGPTEditWithInstructions<cr>",
        desc = "edit code with instructions",
        mode = { "n", "v" },
      },
      { "<leader>af", "<cmd>ChatGPTRun fix_bugs<cr>", desc = "fix bugs", mode = { "n", "v" } },
      { "<leader>at", "<cmd>ChatGPTRun add_tests<cr>", desc = "add tests", mode = { "n", "v" } },
      { "<leader>ao", "<cmd>ChatGPTRun optimize_code<cr>", desc = "optimize code", mode = { "n", "v" } },
      { "<leader>ae", "<cmd>ChatGPTRun explain_code<cr>", desc = "explain code", mode = { "n", "v" } },
    },
  },
}
