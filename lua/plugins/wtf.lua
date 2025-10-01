return {
  "piersolenski/wtf.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    -- Optional: For WtfGrepHistory (pick one)
    -- "nvim-telescope/telescope.nvim",
    "folke/snacks.nvim",
    -- "ibhagwan/fzf-lua",
  },
  opts = {},
  keys = {
    {
      "<leader>wfd",
      mode = { "n", "x" },
      function()
        require("wtf").diagnose()
      end,
      desc = "Debug diagnostic with AI",
    },
    {
      "<leader>wtf",
      mode = { "n", "x" },
      function()
        require("wtf").fix()
      end,
      desc = "Fix diagnostic with AI",
    },
    {
      mode = { "n" },
      "<leader>wfs",
      function()
        require("wtf").search()
      end,
      desc = "Search diagnostic with Google",
    },
    {
      mode = { "n" },
      "<leader>wfp",
      function()
        require("wtf").pick_provider()
      end,
      desc = "Pick provider",
    },
    {
      mode = { "n" },
      "<leader>wfh",
      function()
        require("wtf").history()
      end,
      desc = "Populate the quickfix list with previous chat history",
    },
    {
      mode = { "n" },
      "<leader>wfg",
      function()
        require("wtf").grep_history()
      end,
      desc = "Grep previous chat history with Telescope",
    },
  },
}
