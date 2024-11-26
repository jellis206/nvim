-- local util = require("lspconfig/util")

return {
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "htmx-lsp" } },
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
        htmx = {},
        templ = {},
      },
    },
  },
}
