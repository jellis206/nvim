return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {
      {
        "<leader>cm",
        "<cmd>Mason<cr>",
        desc = "Mason",
      },
    },
    opt = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "angularls",
        "clangd",
        "clang-format",
        "cpplint",
        "cppcheck",
        "cpptools",
        "chrome-debug-adapter",
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
      })
    end,
    config = true,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "mason.nvim",
      "null-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        automatic_installation = true,
        automatic_setup = true,
      })
    end,
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
