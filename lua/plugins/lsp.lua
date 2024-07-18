-- local util = require("lspconfig/util")

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        tsserver = {
          -- root_dir = util.root_pattern(".git", "nx.json", "package.json", "tsconfig.json", "jsconfig.json"),
          settings = {
            typescript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            javascript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            completions = {
              completeFunctionCalls = true,
            },
          },
        },
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
      },
    },
  },
}
