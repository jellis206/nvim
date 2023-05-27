local Util = require("lazyvim.util")
local wk = require("which-key")
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
    o = { "<cmd>Telescope oldfiles<cr>", "Oldfiles" },
    r = { "<cmd>Telescope resume<cr>", "Resume" },
    u = { "<cmd>Telescope undo<cr>", "Undotree" },
  },
  bl = { "<cmd>BufferLineCloseRight<cr>", "BufferLineCloseRight" },
  bh = { "<cmd>BufferLineCloseLeft<cr>", "BufferLineCloseLeft" },
  ["'"] = { "<cmd>Telescope jumplist<cr>", "Jumplist" },
  j = { "<cmd>GrappleCycle forward<cr>", "Grapple Cycle Forward" },
  k = { "<cmd>GrappleCycle backward<cr>", "Grapple cycle backward" },
  a = { "<cmd>GrappleToggle<cr>", "Grapple Toggle" },
  m = { "<cmd>GrapplePopup tags<cr>", "Grapple Popup Tags" },
}, { prefix = "<leader>" })
map("i", "jj", "<esc>", { desc = "Escape Insert Mode" })
map("n", "cp", "<cmd>let @+ = expand('%:p')<cr>", { desc = "Copy Current File Path" })
map("n", "<leader>ul", function()
  Util.toggle("relativenumber")
end, { desc = "Toggle Relative Line #" })
map("n", "<leader>ua", "<cmd>ToggleAutoComplete<cr>", { desc = "Toggle Autocomplete" })
