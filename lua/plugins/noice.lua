-- noice redraws LSP progress every 100 ms by default, and each redraw also
-- repaints the incsearch preview, so the first `/` match flashed while a
-- server reported progress (vtsls loading Bonaparte takes a while).
-- Four updates a second keeps the spinner without the strobe.
return {
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        progress = { throttle = 1000 / 4 },
      },
    },
  },
}
