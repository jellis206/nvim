local Util = require("lazyvim.util")
local wk = require("which-key")
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
keymap.set("n", "x", '"_x')
keymap.set("i", "<C-e>", "<C-o>$") -- move to beginning of line
keymap.set("i", "<C-a>", "<C-o>0") -- move to end of line

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- which key
wk.register({
  ["<space>"] = { Util.telescope("files", { cwd = false }), "Find Files (cwd)" },
  ["/"] = { Util.telescope("live_grep", { cwd = false }), "Grep (cwd)" },
  t = {
    name = "+Telescope",
    o = { "<cmd>Telescope oldfiles<cr>", "oldfiles" },
    r = { "<cmd>Telescope resume<cr>", "resume" },
  },
  bl = { "<cmd>BufferLineCloseRight<cr>", "BufferLineCloseRight" },
  bh = { "<cmd>BufferLineCloseLeft<cr>", "BufferLineCloseLeft" },
  ["'"] = { "<cmd>Telescope jumplist<cr>", "jumplist" },
  j = { "<cmd>GrappleCycle forward<cr>", "Grapple cycle forward" },
  k = { "<cmd>GrappleCycle backward<cr>", "Grapple cycle backward" },
  a = { "<cmd>GrappleToggle<cr>", "Grapple toggle" },
  m = { "<cmd>GrapplePopup tags<cr>", "Grapple popup tags" },
}, { prefix = "<leader>" })

map("i", "jj", "<esc>", { desc = "Escape insert mode" })

map("n", "cp", "<cmd>let @+ = expand('%:p')<cr>", { desc = "Copy current file path to clipboard" })

map("n", "<leader>ut", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })
