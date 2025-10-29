return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
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
      -- Ensure we actually enable highlight/indent (in case opts was empty)
      opts.highlight = opts.highlight or { enable = true }
      opts.indent = opts.indent or { enable = true }

      -- Enable matchup integration (this is what gives you `%` for Python blocks)
      opts.matchup = { enable = true }
    end,
  },
  {
    "andymass/vim-matchup",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    config = function()
      -- Show popup when match is offscreen
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
}
