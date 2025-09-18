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
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-moon",
    },
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "HiPhish/rainbow-delimiters.nvim",
  },
}
