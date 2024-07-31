return {
  -- {
  --   "bluz71/vim-nightfly-colors",
  --   name = "nightfly",
  --   lazy = true,
  --   priority = 1000,
  -- },
  --{
  --  "whatyouhide/vim-gotham",
  --  name = "gotham",
  --  lazy = true,
  --  priority = 1000,
  --},
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-moon",
    },
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  -- {
  --   vim.api.nvim_command([[
  --   augroup ChangeBackgroudColour
  --       autocmd colorscheme * :hi normal guibg=000000
  --   augroup END
  --   ]])
  -- },
  {
    url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git",
    name = "rainbow-delimiters",
  },
}
