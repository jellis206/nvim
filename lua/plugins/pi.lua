return {
    "carderne/pi-nvim",
    opts = {
        set_default_keymaps = false,
    },
    keys = {
        {
            "<leader>aa",
            "<cmd>Pi<cr>",
            mode = { "n", "v" },
            desc = "AI: Ask Pi",
        },
        {
            "<leader>aS",
            "<cmd>PiSessions<cr>",
            desc = "AI: Pi Sessions",
        },
    },
}
