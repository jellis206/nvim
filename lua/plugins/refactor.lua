return {
  {
    "ThePrimeagen/refactoring.nvim",
    config = function()
      require("refactoring").setup()
      require("telescope").load_extension("refactoring")
    end,
  }
}
