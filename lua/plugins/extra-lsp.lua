return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
          vim.keymap.set("n", "<leader>cu", "TypescriptRemoveUnused", { desc = "Remove Unused Variables", buffer = buffer })
        end)
      end,
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- typescript will be automatically installed with mason and loaded with lspconfig
        tsserver = {},
        -- angularls will be automatically installed with mason and loaded with lspconfig
        angularls = {
          root_dir = function(fname)
            return vim.loop.cwd()
          end,
        },
      },
    },
  },
}