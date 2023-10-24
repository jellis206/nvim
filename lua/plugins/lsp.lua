-- local util = require("lspconfig/util")

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(client, buffer)
          if client.name == "tsserver" then
            vim.keymap.set("n", "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", {
              buffer = buffer,
              desc = "Organize Imports",
            })
            vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<CR>", {
              desc = "Rename File",
              buffer = buffer,
            })
            vim.keymap.set("n", "<leader>cu", "<cmd>TypescriptRemoveUnused<CR>", {
              desc = "Remove Unused Variables",
              buffer = buffer,
            })
          end
        end)
      end,
    },
    opts = {
      autoformat = true,
      servers = {
        tsserver = {
          -- root_dir = util.root_pattern(".git", "nx.json", "package.json", "tsconfig.json", "jsconfig.json"),
        },
        angularls = {
          -- root_dir = util.root_pattern(".git", "nx.json", "angular.json", "tsconfig.json"),
          root_dir = function()
            return vim.loop.cwd()
          end,
        },
      },
    },
  },
}
