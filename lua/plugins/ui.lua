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
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({
            silent = true,
            pending = true,
          })
        end,
        desc = "Delete all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      background_colour = "#000000",
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
  },
  {
    url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git",
    name = "rainbow-delimiters",
  },
}
