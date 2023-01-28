-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
keymap.set("n", "x", '"_x')
keymap.set("i", "<C-e>", "<C-o>$") -- move to beginning of line
keymap.set("i", "<C-a>", "<C-o>0") -- move to end of line