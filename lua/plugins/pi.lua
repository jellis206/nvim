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
            "<leader>af",
            function()
                require("config.pi_context").send_files()
            end,
            desc = "AI: Send Files",
        },
        {
            "<leader>ab",
            function()
                require("config.pi_context").send_buffers()
            end,
            desc = "AI: Send Buffers",
        },
        {
            "<leader>at",
            function()
                Snacks.terminal({ "pi" }, { cwd = vim.uv.cwd() })
            end,
            desc = "AI: Pi Terminal",
        },
        {
            "<leader>aS",
            "<cmd>PiSessions<cr>",
            desc = "AI: Pi Sessions",
        },
    },
}
