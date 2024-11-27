local wk = require("which-key")
local mouse_enabled = true

wk.add({
  { "<leader>'", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
  { "<leader>/", LazyVim.pick("live_grep", { root = true }), desc = "Grep" },
  { "<leader><space>", LazyVim.pick("files", { root = true }), desc = "Find Files" },
  { "<leader>A", "<cmd>Grapple reset<cr>", desc = "Clear All Grapple Tags" },
  { "<leader>a", "<cmd>Grapple toggle<cr>", desc = "Grapple Toggle" },
  { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "BufferLineCloseLeft" },
  { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "BufferLineCloseRight" },
  { "<leader>cp", "<cmd> let @+ = expand('%:p') <cr>", desc = "Copy Current File Path" },
  { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" },
  { "<leader>j", "<cmd>Grapple cycle forward<cr>", desc = "Grapple Cycle Forward" },
  { "<leader>k", "<cmd>Grapple cycle backward<cr>", desc = "Grapple cycle backward" },
  { "<leader>p", group = "popups" },
  { "<leader>pg", "<cmd>Grapple open_tags<cr>", desc = "Grapple Popup Tags" },
  { "<leader>pm", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
  { "<leader>s", group = "search" },
  { "<leader>sW", LazyVim.pick("grep_string", { word_match = "-w", root = false }), desc = "Word (cwd)" },
  { "<leader>sw", LazyVim.pick("grep_string", { word_match = "-w", root = true }), desc = "Word (root dir)" },
  { "<leader>ua", "<cmd>ToggleAutoComplete<cr>", desc = "Toggle Autocomplete" },
  { "<leader>ug", "<cmd>GitBlameToggle<cr>", desc = "Toggle Git Blame" },
  { "<leader>ut", "<cmd>Telescope undo<cr>", desc = "Undotree" },
})
Snacks.toggle
  .new({
    name = "Mouse",
    get = function()
      return mouse_enabled
    end,
    set = function(state)
      vim.opt.mouse = state and "a" or ""
      mouse_enabled = state
    end,
  })
  :map("<leader>uM")

Snacks.toggle
  .new({
    name = "Copilot",
    get = function()
      return not require("copilot.client").is_disabled()
    end,
    set = function(state)
      local copilot = require("copilot.command")
      if state then
        copilot.enable()
      else
        copilot.disable()
      end
    end,
  })
  :map("<leader>uc")

wk.add({
  {
    mode = { "v" },
    { "<leader>s", group = "Search" },
    { "<leader>sW", LazyVim.pick("grep_string", { root = false }), desc = "Selection (cwd)" },
    { "<leader>sw", LazyVim.pick("grep_string", { root = true }), desc = "Selection (root dir)" },
  },
})

wk.add({
  {
    mode = { "i" },
    { "<C-$>", "<c-o>$", desc = "Move to end of line" },
    { "<C-0>", "<c-o>0", desc = "Move to beginning of line" },
    { "jj", "<esc>", desc = "Escape Insert Mode" },
    { "kk", "<esc>", desc = "Escape Insert Mode" },
  },
})

-- toggleterm
-- local t = require("toggleterm.terminal")
-- local terminal = t.Terminal
-- wk.add({
--   { "<leader>t", group = "Terminal" },
--   { "<leader>th", "<cmd>ToggleTerm size=70 direction=vertical<cr>", desc = "Toggle Terminal (vertical)" },
--   { "<leader>tj", "<cmd>ToggleTerm size=15 direction=horizontal<cr>", desc = "Toggle Terminal (horizontal)" },
--   {
--     "<leader>tn",
--     function()
--       local current = t.get_all()[1]
--       local new_direction = "horizontal"
--       if current:is_float() then
--         return
--       elseif current:is_tab() then
--         new_direction = "tab"
--       elseif current.direction == "vertical" then
--         new_direction = "vertical"
--       end
--       terminal:new({ direction = new_direction }):toggle()
--     end,
--     desc = "New Terminal",
--   },
--   { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
-- })
