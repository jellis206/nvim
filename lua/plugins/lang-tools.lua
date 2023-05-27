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
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
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
