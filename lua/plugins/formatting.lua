return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    config = true,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    config = function()
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting -- to setup formatters
      local diagnostics = null_ls.builtins.diagnostics -- to setup linters
      local code_actions = null_ls.builtins.code_actions -- to setup linters
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      null_ls.setup({
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
            args = { "--style=google", "--quiet", "--indent=spaces=2" },
          }),

          -- diagnostics.semgrep,
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
            filetypes = {},
          }),
        },
        -- configure format on save
        on_attach = function(current_client, bufnr)
          if current_client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  filter = function(client)
                    --  only use null-ls for formatting instead of lsp server
                    return client.name == "null-ls"
                  end,
                  bufnr = bufnr,
                })
              end,
            })
          end
        end,
      })
    end,
  },

  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = { "mason.nvim", "null-ls.nvim" },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = nil,
        automatic_installation = true,
        automatic_setup = false,
      })
    end,
  },
}
