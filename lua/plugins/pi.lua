return {
    "carderne/pi-nvim",
    config = function()
        require("pi-nvim").setup({
            set_default_keymaps = false,
        })

        vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>Pi<cr>", {
            desc = "AI: Ask Pi",
        })

        vim.keymap.set("v", "<leader>as", "<cmd>PiSendSelection<cr>", {
            desc = "AI: Send Selection",
        })

        vim.keymap.set("n", "<leader>af", "<cmd>PiSendFile<cr>", {
            desc = "AI: Send File",
        })

        vim.keymap.set("n", "<leader>ab", "<cmd>PiSendBuffer<cr>", {
            desc = "AI: Send Buffer",
        })

        vim.keymap.set("n", "<leader>ai", "<cmd>PiPing<cr>", {
            desc = "AI: Ping Pi",
        })

        vim.keymap.set("n", "<leader>aS", "<cmd>PiSessions<cr>", {
            desc = "AI: Pi Sessions",
        })
    end,
}
