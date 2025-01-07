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
    "jellis206/tokyonight.nvim",
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
    url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git",
    name = "rainbow-delimiters",
  },
}
