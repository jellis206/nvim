return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "angular-language-server",
        "clangd",
        "clang-format",
        "cpplint",
        "cpptools",
        "js-debug-adapter",
        "node-debug2-adapter",
        "debugpy",
        "prettierd",
        "reorder-python-imports",
        "ruff",
        "rust-analyzer",
        "shfmt",
        "rubocop",
        "stylelint",
        "misspell",
        "google-java-format",
      },
    },
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      automatic_installation = true,
      automatic_setup = true,
      handlers = {},
      ensure_installed = {},
    },
  },
}
