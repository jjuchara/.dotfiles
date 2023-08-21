-- TODO: create key shortcuts
return {
  "Bryley/neoai.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  cmd = {
    "NeoAI",
    "NeoAIOpen",
    "NeoAIClose",
    "NeoAIToggle",
    "NeoAIContext",
    "NeoAIContextOpen",
    "NeoAIContextClose",
    "NeoAIInject",
    "NeoAIInjectCode",
    "NeoAIInjectContext",
    "NeoAIInjectContextCode",
  },
  keys = {
    { "<leader>A", desc = "ChatGpt" },
    { "<leader>As", desc = "summarize text" },
    { "<leader>Am", desc = "generate git message" },
    { "<leader>Ao", "<cmd>NeoAI<CR>", desc = "Toggle normal mode" },
    { "<leader>Ac", "<cmd>NeoAIContext<CR>", desc = "Toggle context mode" },
    { "<leader>Ai", "<cmd>NeoAIInjectContextCode<CR>", desc = "Direct inject code snippet" },
  },
  config = function()
    require("neoai").setup {
      -- Options go here
    }
  end,
}
