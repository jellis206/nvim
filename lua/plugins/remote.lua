return {
  {
    "chipsenkbeil/distant.nvim",
    branch = "fix/AddCheckForFailingToStartLspClient",
    config = function()
      require("distant"):setup()
    end,
  },
}
