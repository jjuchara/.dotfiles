local keymap = vim.api.nvim_set_keymap
return {
  "VonHeikemen/fine-cmdline.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  config = function()
    require("fine-cmdline").setup {
      cmdline = {
        enable_keymaps = true,
        smart_history = true,
        prompt = ": ",
      },
      popup = {
        position = {
          row = "10%",
          col = "50%",
        },
        size = {
          width = "60%",
        },
        border = {
          style = "rounded",
        },
        win_options = {
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        },
      },
      keymap("n", ":", "<cmd>FineCmdline<CR>", { noremap = true }),
    }
  end,
}
