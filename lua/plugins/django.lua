return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "djlint",
        "django-template-lsp",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "python", "htmldjango", "javascript", "django_template" })
      return opts
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        djlsp = {},
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        htmldjango = { "djlint" },
      },
      formatters = {
        djlint = {
          args = { "--reformat", "-" },
        },
      },
    },
  },
}
