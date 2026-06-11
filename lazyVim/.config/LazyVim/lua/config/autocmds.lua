-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--#region
--

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local groups = {
      "Normal", "NormalNC", "NormalFloat",
      "FloatBorder", "FloatTitle",
      "SignColumn", "FoldColumn",
      "EndOfBuffer",
    }
    for _, group in ipairs(groups) do
      vim.api.nvim_set_hl(0, group, { bg = "NONE" })
    end
  end,
})
