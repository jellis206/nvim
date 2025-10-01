return {
  "debugloop/telescope-undo.nvim",
  dependencies = { -- telescope is already in LazyVim, but make sure it's listed
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>fu", "<cmd>Telescope undo<cr>", desc = "Undo history" },
  },
  config = function()
    require("telescope").load_extension("undo")
  end,
}
