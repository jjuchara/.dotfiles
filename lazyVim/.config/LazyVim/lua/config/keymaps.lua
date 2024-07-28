-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Move to window using the <ctrl> hjkl keys
local keymap = vim.keymap.set

-- Move Lines
keymap("n", "<m-S-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
keymap("n", "<m-S-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
keymap("i", "<m-S-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
keymap("i", "<m-S-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
keymap("v", "<m-S-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
keymap("v", "<m-S-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- save file
keymap("n", "<leader>ww", "<cmd>w<cr><esc>", { desc = "Save file" })

--   gl as  open diagnostic
keymap("n", "gl", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
