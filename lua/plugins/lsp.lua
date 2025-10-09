-- local util = require("lspconfig/util")

return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "angular-language-server",
        "typescript-language-server",
        "clang-format",
        "cpplint",
        "cpptools",
        "js-debug-adapter",
        "debugpy",
        "prettierd",
        "reorder-python-imports",
        "ruff",
        "rust-analyzer",
        "shfmt",
        "rubocop",
        "stylelint",
        "misspell",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        angularls = {
          -- root_dir = util.root_pattern(".git", "nx.json", "angular.json", "tsconfig.json"),
          root_dir = function()
            return vim.loop.cwd()
          end,
          -- root_dir = function()
          --   return vim.fs.find({ ".git", "nx.json", "package.json" }, {
          --     upward = true,
          --     stop = vim.uv.os_homedir(),
          --   })
          -- end,
        },
        templ = {},
        -- dartls = {},
      },
    },
  },
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional for vim.ui.select
    },
    config = true,
  },
}
