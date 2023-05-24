return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- ensure these language parsers are installed
      vim.list_extend(opts.ensure_installed, {
        -- Common
        "html",
        "css",
        "javascript",
        "typescript",
        "c",
        "cpp",
        "json",
        "java",
        "python",
        "rust",

        -- Util
        "comment",
        "diff",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "query",
        "regex",

        -- Less common
        "bash",
        "latex",
        "lua",
        "markdown",
        "markdown_inline",
        "vim",
        "go",
        "tsx",
        "toml",
        "yaml",
        "dockerfile",
        "graphql",

        -- Misc
        "elixir",
        "http",
        "llvm",
        "make",
        "r",
        "sql",
      })
    end,
  },
}
