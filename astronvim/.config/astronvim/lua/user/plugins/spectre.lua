return {
  "windwp/nvim-spectre",
  -- stylua: ignore
  keys = { 
    { "<leader>r", desc = "Spectre" },
    { "<leader>rF", function() require("spectre").open() end, desc = "Replace in files" },
    { "<leader>rf", function() require("spectre").open_file_search({select_word=true}) end, desc = "Replace in current file" },
    {"<leader>rv", function() require("spectre").open_visual({select_word=true}) end, desc = "Search current word"}
  },
}
