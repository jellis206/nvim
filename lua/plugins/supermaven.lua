return {
  {
    "supermaven-inc/supermaven-nvim",
    opts = function()
      vim.api.nvim_set_hl(0, "CmpItemKindSupermaven", { fg = "#6CC644" })
    end,
  },
}
