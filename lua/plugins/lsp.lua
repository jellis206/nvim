return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").on_attach(function(client, buffer)
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
        tsserver = {},
        angularls = {
          root_dir = function(fname)
            return vim.loop.cwd()
          end,
        },
      },
    },
  },
}
