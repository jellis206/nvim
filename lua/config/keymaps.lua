local wk = require("which-key")
-- local supermaven_enabled = false
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
  {
    "<leader>uc",
    function()
      local copilot = require("copilot.command")
      local copilot_enabled = not require("copilot.client").is_disabled()

      if copilot_enabled then
        copilot.disable()
        copilot_enabled = false
      else
        copilot.enable()
        copilot_enabled = true
      end
      vim.schedule(function()
        copilot.status()
      end)
    end,
    desc = "Toggle Copilot",
  },
  -- {
  --   "<leader>um",
  --   function()
  --     local supermaven = require("supermaven-nvim.api")
  --     if supermaven_enabled then
  --       supermaven.stop()
  --     else
  --       supermaven.start()
  --     end
  --     supermaven_enabled = not supermaven_enabled
  --   end,
  --   desc = "Toggle Supermaven",
  -- },
  { "<leader>ug", "<cmd>GitBlameToggle<cr>", desc = "Toggle Git Blame" },
  { "<leader>ut", "<cmd>Telescope undo<cr>", desc = "Undotree" },
  {
    "<leader>uM",
    function()
      if mouse_enabled then
        vim.opt.mouse = ""
        mouse_enabled = false
      else
        vim.opt.mouse = "a"
        mouse_enabled = true
      end
    end,
    desc = "Toggle Mouse Mode",
  },
})
Snacks.toggle
  .option("mouse", { off = mouse_enabled == false, on = mouse_enabled == true, name = "Mouse" })
  :map("<leader>uM")

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
local t = require("toggleterm.terminal")
local terminal = t.Terminal
wk.add({
  { "<leader>t", group = "Terminal" },
  { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle Terminal (float)" },
  { "<leader>th", "<cmd>ToggleTerm size=70 direction=vertical<cr>", desc = "Toggle Terminal (vertical)" },
  { "<leader>tj", "<cmd>ToggleTerm size=15 direction=horizontal<cr>", desc = "Toggle Terminal (horizontal)" },
  {
    "<leader>tn",
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
      terminal:new({ direction = new_direction }):toggle()
    end,
    desc = "New Terminal",
  },
  { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
})
