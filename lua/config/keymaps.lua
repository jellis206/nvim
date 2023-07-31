local Util = require("lazyvim.util")
local wk = require("which-key")
local keymap = vim.keymap
keymap.set("n", "x", '"_x')

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
  bf = { Util.telescope("live_grep", { grep_open_files = true }), "Grep in open buffers" },
  bl = { "<cmd>BufferLineCloseRight<cr>", "BufferLineCloseRight" },
  bh = { "<cmd>BufferLineCloseLeft<cr>", "BufferLineCloseLeft" },
  ["'"] = { "<cmd>Telescope jumplist<cr>", "Jumplist" },
  j = { "<cmd>GrappleCycle forward<cr>", "Grapple Cycle Forward" },
  k = { "<cmd>GrappleCycle backward<cr>", "Grapple cycle backward" },
  a = { "<cmd>GrappleToggle<cr>", "Grapple Toggle" },
  A = { "<cmd>GrappleReset<cr>", "Clear All Grapple Tags" },
  m = { "<cmd>GrapplePopup tags<cr>", "Grapple Popup Tags" },
  cp = { "<cmd> let @+ = expand('%:p') <cr>", "Copy Current File Path" },
  ua = { "<cmd>ToggleAutoComplete<cr>", "Toggle Autocomplete" },
  ul = {
    function()
      Util.toggle("relativenumber")
    end,
    "Toggle Relative Line #",
  },
  up = { "<cmd>GitBlameToggle<cr>", "Toggle Git Blame" },
  r = {
    name = "+Refactoring",
    b = {
      function()
        require("refactoring").refactor("Extract Block")
      end,
      "Extract Block",
    },
    bf = {
      function()
        require("refactoring").refactor("Extract Block To File")
      end,
      "Extract Block To File",
    },
    r = {
      function()
        require("telescope").extensions.refactoring.refactors()
      end,
      "Refactor",
    },
    i = {
      function()
        require("refactoring").refactor("Inline Variable")
      end,
      "Inline Variable",
    },
  },
}, { prefix = "<leader>" })

wk.register({
  r = {
    name = "+Refactoring",
    e = {
      function()
        require("refactoring").refactor("Extract Function")
      end,
      "Extract Function",
    },
    ef = {
      function()
        require("refactoring").refactor("Extract Function To File")
      end,
      "Extract Function To File",
    },
    i = {
      function()
        require("refactoring").refactor("Inline Variable")
      end,
      "Inline Variable",
    },
    r = {
      function()
        require("telescope").extensions.refactoring.refactors()
      end,
      "Refactor",
    },
    v = {
      function()
        require("refactoring").refactor("Extract Variable")
      end,
      "Extract Variable",
    },
  },
}, { prefix = "<leader>", mode = "x" })

wk.register({
  jj = { "<esc>", "Escape Insert Mode" },
  ["<C-e>"] = { "<c-o>$", "Move to end of line" },
  ["<C-a>"] = { "<c-o>0", "Move to beginning of line" },
}, { mode = "i" })
