-- Every screen update makes Neovim hide and re-show the terminal cursor, so
-- noice's animated LSP spinner made the cursor (parked on the first `/` match)
-- blink while vtsls loaded Bonaparte. Showing progress without the spinner
-- means the screen only changes when the server reports new progress.
return {
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        progress = {
          format = {
            {
              "{progress} ",
              key = "progress.percentage",
              contents = { { "{data.progress.message} " } },
            },
            "({data.progress.percentage}%) ",
            { "{data.progress.title} ", hl_group = "NoiceLspProgressTitle" },
            { "{data.progress.client} ", hl_group = "NoiceLspProgressClient" },
          },
        },
      },
    },
  },
}
