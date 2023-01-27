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
        -- Common
        'html', 'css', 'javascript', 'typescript', 'c', 'cpp', 'json', 'java', 'python',
        -- Util
        'comment', 'diff', 'git_rebase', 'gitattributes', 'gitcommit', 'help', 'query', 'regex',
        -- Less common
        'bash', 'haskell', 'latex', 'lua', 'markdown', 'markdown_inline', 'nix', 'vim',
        'tsx', 'json5', 'jsonc', 'hjson', 'jsonnet', 'toml', 'yaml', 'dockerfile', 'bibtex', 'scheme',
        -- Misc
        'awk', 'ebnf', 'elixir', 'fennel', 'http', 'julia', 'llvm', 'make', 'r', 'rst', 'sql',
      },
      -- auto install above language parsers
      auto_install = true,
    },
  },
}