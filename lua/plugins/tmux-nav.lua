return {
  {
    "christoomey/vim-tmux-navigator",
    -- herdr-navigator owns ctrl+h/j/k/l inside herdr
    cond = vim.env.HERDR_ENV ~= "1",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    -- pairs with the herdr-navigator plugin bound in ~/.config/herdr/config.toml
    "kaar/nvim-herdr-navigator",
    cond = vim.env.HERDR_ENV == "1",
    lazy = false,
  },
}
