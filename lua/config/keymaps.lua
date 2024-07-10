local wk = require("which-key")
local keymap = vim.keymap
keymap.set("n", "x", '"_x')

-- which key
wk.register({
  ["<space>"] = { LazyVim.pick("files", { root = true }), "Find Files" },
  ["/"] = { LazyVim.pick("live_grep", { root = true }), "Grep" },
  s = {
    name = "+Search",
    W = { LazyVim.pick("grep_string", { word_match = "-w", root = false }), "Word (cwd)" },
    w = { LazyVim.pick("grep_string", { word_match = "-w", root = true }), "Word (root dir)" },
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
    W = { LazyVim.pick("grep_string", { root = false }), "Selection (cwd)" },
    w = { LazyVim.pick("grep_string", { root = true }), "Selection (root dir)" },
  },
}, { prefix = "<leader>", mode = "v" })

wk.register({
  jj = { "<esc>", "Escape Insert Mode" },
  ["<C-$>"] = { "<c-o>$", "Move to end of line" },
  ["<C-0>"] = { "<c-o>0", "Move to beginning of line" },
}, { mode = "i" })

--toggleterm
local t = require("toggleterm.terminal")
local terminal = t.Terminal
wk.register({
  t = {
    name = "+Terminal",
    t = { "<cmd>ToggleTerm<cr>", "Toggle Terminal" },
    j = { "<cmd>ToggleTerm size=15 direction=horizontal<cr>", "Toggle Terminal (horizontal)" },
    h = { "<cmd>ToggleTerm size=70 direction=vertical<cr>", "Toggle Terminal (vertical)" },
    f = { "<cmd>ToggleTerm direction=float<cr>", "Toggle Terminal (float)" },
    n = {
      function()
        local current = t.get_all()[1]
        local new_direction = "horizontal"
        if current:is_float() then
          return
        elseif current:is_tab() then
          new_direction = "tab"
        elseif current.direction == "vertical" then
          new_direction = "vertical"
        end
        print("current direction" .. current.direction)
        print("New Direction: " .. new_direction)
        terminal:new({ direction = new_direction }):toggle()
      end,
      "New Terminal",
    },
  },
}, { prefix = "<leader>" })
