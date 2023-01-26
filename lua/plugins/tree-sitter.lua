return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- enable syntax highlighting
      highlight = {
        enable = true,
      },
      -- enable indentation
      indent = { enable = true },
      -- enable autotagging (w/ nvim-ts-autotag plugin)
      autotag = { enable = true },
      -- ensure these language parsers are installed
      ensure_installed = {
        "bash",
        "cpp",
        "css",
        "dockerfile",
        "gitignore",
        "graphql",
        "help",
        "html",
        "java",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "svelte",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
      -- auto install above language parsers
      auto_install = true,
    },
  },
}