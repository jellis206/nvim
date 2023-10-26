return {
  {
    "ThePrimeagen/refactoring.nvim",
    config = function()
      require("refactoring").setup({})
      require("telescope").load_extension("refactoring")
    end,
  },
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim",
    },
    config = function()
      require("lsp-file-operations").setup({})
    end,
  },
}
