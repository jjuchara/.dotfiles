return {
  "lvimuser/lsp-inlayhints.nvim",
  event = "LspAttach",
  keys = {
    {
      "<leader>ih",
      function() require("lsp-inlayhints").toggle() end,
      desc = "Toggle inlay hints",
    },
  },
  opts = {
    inlay_hints = {
      parameter_hints = {
        show = true,
        prefix = "<- ",
        separator = ", ",
        remove_colon_start = false,
        remove_colon_end = true,
      },
      type_hints = {
        show = true,
        prefix = " » ",
        separator = ", ",
        remove_colon_start = false,
        remove_colon_end = false,
      },
      only_current_line = false,
      labels_separator = "  ", -- gap between type hints and parameter hints
      highlight = "Comment", -- see `:highlight` for more options
    },
  },
}
