local wk = require("which-key")

-- Normal mode mappings
wk.add({
  -- Telescope and search
  { "<leader>'", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
  { "<leader>/", LazyVim.pick("live_grep", { root = true }), desc = "Grep" },
  { "<leader><space>", LazyVim.pick("files", { root = true }), desc = "Find Files" },
  { "<leader>s", group = "search" },
  { "<leader>sW", LazyVim.pick("grep_string", { word_match = "-w", root = false }), desc = "Word (cwd)" },
  { "<leader>sw", LazyVim.pick("grep_string", { word_match = "-w", root = true }), desc = "Word (root dir)" },

  -- Buffer management
  { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close Left Buffers" },
  { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close Right Buffers" },

  -- Grapple
  { "<leader>a", group = "Grapple" },
  { "<leader>aA", "<cmd>Grapple reset<cr>", desc = "Clear All Grapple Tags" },
  { "<leader>aa", "<cmd>Grapple toggle<cr>", desc = "Grapple Toggle" },
  { "<leader>j", "<cmd>Grapple cycle forward<cr>", desc = "Grapple Cycle Forward" },
  { "<leader>k", "<cmd>Grapple cycle backward<cr>", desc = "Grapple cycle backward" },
  { "<leader>pg", "<cmd>Grapple open_tags<cr>", desc = "Grapple Popup Tags" },

  -- Utility commands
  { "<leader>A", group = "avante" },
  { "<leader>cp", "<cmd>let @+ = expand('%:p')<cr>", desc = "Copy Current File Path" },
  { "<leader>p", group = "popups" },
  {
    "<leader>pd",
    function()
      Snacks.dashboard()
    end,
    desc = "Show Dashboard",
  },
  { "<leader>pm", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
  { "<leader>ut", "<cmd>Telescope undo<cr>", desc = "Undotree" },
})

-- Visual mode mappings
wk.add({
  mode = { "v" },
  { "<leader>s", group = "Search" },
  { "<leader>sW", LazyVim.pick("grep_string", { root = false }), desc = "Selection (cwd)" },
  { "<leader>sw", LazyVim.pick("grep_string", { root = true }), desc = "Selection (root dir)" },
})

-- Insert mode mappings
wk.add({
  mode = { "i" },
  { "<C-$>", "<c-o>$", desc = "Move to end of line" },
  { "<C-0>", "<c-o>0", desc = "Move to beginning of line" },
  { "jj", "<esc>", desc = "Escape Insert Mode" },
  { "kk", "<esc>", desc = "Escape Insert Mode" },
})

-- Toggle configurations
local function create_toggle(name, get_fn, set_fn, key)
  Snacks.toggle
    .new({
      name = name,
      get = get_fn,
      set = set_fn,
    })
    :map(key)
end

-- Auto-complete toggle
local auto_cmp_enabled = true
create_toggle("Auto Complete", function()
  return auto_cmp_enabled
end, function(state)
  auto_cmp_enabled = state
  vim.cmd("ToggleAutoComplete")
end, "<leader>ua")

-- Copilot toggle
create_toggle("Copilot", function()
  return not require("copilot.client").is_disabled()
end, function(state)
  local copilot = require("copilot.command")
  if state then
    copilot.enable()
  else
    copilot.disable()
  end
end, "<leader>uc")

-- Git blame toggle
local gb_enabled = true
create_toggle("Git Blame", function()
  return gb_enabled
end, function(state)
  gb_enabled = state
  vim.cmd("GitBlameToggle")
end, "<leader>uB")

-- Mouse toggle
local mouse_enabled = true
create_toggle("Mouse", function()
  return mouse_enabled
end, function(state)
  vim.opt.mouse = state and "a" or ""
  mouse_enabled = state
end, "<leader>uM")
