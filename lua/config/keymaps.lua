local wk = require("which-key")
local keymap = vim.keymap
keymap.set("n", "x", '"_x')

-- which key
wk.register({
  ["<space>"] = { LazyVim.pick("files", { cwd = false }), "Find Files (cwd)" },
  ["/"] = { LazyVim.pick("live_grep", { cwd = false }), "Grep (cwd)" },
  s = {
    name = "+Search",
    W = { LazyVim.pick("grep_string", { word_match = "-w" }), "Word (root dir)" },
    w = { LazyVim.pick("grep_string", { word_match = "-w", cwd = false }), "Word (cwd)" },
  },
  ut = { "<cmd>Telescope undo<cr>", "Undotree" },
  bf = { LazyVim.pick("live_grep", { grep_open_files = true }), "Grep in open buffers" },
  bl = { "<cmd>BufferLineCloseRight<cr>", "BufferLineCloseRight" },
  bh = { "<cmd>BufferLineCloseLeft<cr>", "BufferLineCloseLeft" },
  ["'"] = { "<cmd>Telescope jumplist<cr>", "Jumplist" },
  j = { "<cmd>Grapple cycle forward<cr>", "Grapple Cycle Forward" },
  k = { "<cmd>Grapple cycle backward<cr>", "Grapple cycle backward" },
  a = { "<cmd>Grapple toggle<cr>", "Grapple Toggle" },
  A = { "<cmd>Grapple reset<cr>", "Clear All Grapple Tags" },
  m = { "<cmd>Grapple open_tags<cr>", "Grapple Popup Tags" },
  cp = { "<cmd> let @+ = expand('%:p') <cr>", "Copy Current File Path" },
  ua = { "<cmd>ToggleAutoComplete<cr>", "Toggle Autocomplete" },
  cs = { "<cmd>SymbolsOutline<cr>", "Symbols Outline" },
  uc = { "<cmd>ToggleCopilot<cr>", "Toggle Copilot" },
  ul = {
    function()
      LazyVim.toggle("relativenumber")
    end,
    "Toggle Relative Line #",
  },
  ug = { "<cmd>GitBlameToggle<cr>", "Toggle Git Blame" },
}, { prefix = "<leader>" })

wk.register({
  s = {
    name = "+Search",
    W = { LazyVim.pick("grep_string"), "Selection (root dir)" },
    w = { LazyVim.pick("grep_string", { cwd = false }), "Selection (cwd)" },
  },
}, { prefix = "<leader>", mode = "v" })

wk.register({
  jj = { "<esc>", "Escape Insert Mode" },
  ["<C-$>"] = { "<c-o>$", "Move to end of line" },
  ["<C-0>"] = { "<c-o>0", "Move to beginning of line" },
}, { mode = "i" })

wk.register({
  fe = {
    function()
      require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
    end,
    "Explorer NeoTree (cwd)",
  },
  fE = {
    function()
      require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
    end,
    "Explorer NeoTree (root dir)",
  },
  e = { "<leader>fe", "Explorer NeoTree (cwd)", remap = true },
  E = { "<leader>fE", "Explorer NeoTree (root dir)", remap = true },
}, { prefix = "<leader>" })

--toggleterm
local terminal = require("toggleterm.terminal").Terminal
wk.register({
  t = {
    name = "+Terminal",
    t = { "<cmd>ToggleTerm<cr>", "Toggle Terminal" },
    j = { "<cmd>ToggleTerm size=15 direction=horizontal<cr>", "Toggle Terminal (horizontal)" },
    h = { "<cmd>ToggleTerm size=70 direction=vertical<cr>", "Toggle Terminal (vertical)" },
    f = { "<cmd>ToggleTerm direction=float<cr>", "Toggle Terminal (float)" },
    n = {
      function()
        terminal:new():toggle()
      end,
      "New Terminal",
    },
    c = {
      function()
        terminal:close()
      end,
      "Close Terminal",
    },
  },
}, { prefix = "<leader>" })
