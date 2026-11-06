-- noice animates LSP progress with a spinner that redraws ten times a second.
-- Each tick also redraws the incsearch preview, so the first `/` match flashes
-- for as long as a server reports progress (vtsls loading Bonaparte takes a while).
return {
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        progress = { enabled = false },
      },
    },
  },
}
