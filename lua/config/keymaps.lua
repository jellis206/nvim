local Util = require("lazyvim.util")
local wk = require("which-key")
local keymap = vim.keymap
keymap.set("n", "x", '"_x')

-- which key
wk.register({
  s = {
    name = "+Search",
    W = { Util.telescope("grep_string", { word_match = "-w" }), "Word (root dir)" },
    w = { Util.telescope("grep_string", { word_match = "-w", cwd = false }), "Word (cwd)" },
  },
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
      Util.toggle("relativenumber")
    end,
    "Toggle Relative Line #",
  },
  ug = { "<cmd>GitBlameToggle<cr>", "Toggle Git Blame" },
}, { prefix = "<leader>" })

wk.register({
  s = {
    name = "+Search",
    W = { Util.telescope("grep_string"), "Selection (root dir)" },
    w = { Util.telescope("grep_string", { cwd = false }), "Selection (cwd)" },
  },
}, { prefix = "<leader>", mode = "v" })

wk.register({
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
    f = {
      function()
        require("refactoring").refactor("Extract Function")
      end,
      "Extract Function",
    },
    ff = {
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

wk.register({
  fe = {
    function()
      require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
    end,
    "Explorer NeoTree (cwd)",
  },
  fE = {
    function()
      require("neo-tree.command").execute({ toggle = true, dir = Util.root() })
    end,
    "Explorer NeoTree (root dir)",
  },
  e = { "<leader>fe", "Explorer NeoTree (cwd)", remap = true },
  E = { "<leader>fE", "Explorer NeoTree (root dir)", remap = true },
}, { prefix = "<leader>" })
