return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- ensure these language parsers are installed
      vim.list_extend(opts.ensure_installed, {
        -- Common
        "typescript",
        "javascript",
        "html",
        "css",
        "go",
        "templ",
        "c",
        "cpp",
        "json",
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
        "zig",
        "svelte",
        "vue",
        "bash",
        "sql",
        "lua",
        "markdown",
        "markdown_inline",
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
        "vim",
        "latex",
        "typst",
      })
    end,
  },
}
