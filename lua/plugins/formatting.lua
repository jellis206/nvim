return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      local formatting = null_ls.builtins.formatting -- to setup formatters
      local diagnostics = null_ls.builtins.diagnostics -- to setup linters
      local code_actions = null_ls.builtins.code_actions -- to setup linters
      return {
        sources = {
          formatting.stylua,
          formatting.standardrb,
          formatting.prettierd, -- js/ts formatter
          formatting.stylua, -- lua formatter
          formatting.reorder_python_imports,
          formatting.standardrb,
          formatting.swiftlint,
          formatting.ruff,

          formatting.astyle.with({
            args = { "--style=google", "--quiet", "--indent=spaces=2"}
          }),

          diagnostics.semgrep,
          diagnostics.cppcheck,
          diagnostics.cpplint,
          diagnostics.flake8,
          diagnostics.eslint_d.with({ -- js/ts linter
            -- only enable eslint if root has .eslintrc.js
            condition = function(utils)
              return utils.root_has_file(".eslintrc.js") -- change file extension if you use something else
            end,
          }),

          code_actions.refactoring.with({
            filetypes = {}
          }),
        },
      }
    end,
    config = true,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = "BufReadPre",
    opts = {
      ensure_installed = nil,
      automatic_installation = true,
      automatic_setup = false,
    },
    config = true,
  },
}