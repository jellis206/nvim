-- oxlint runs alongside eslint (see lazy.lua's linting.eslint extra).
-- It only attaches when a project actually uses oxlint: the lspconfig root_dir
-- looks for .oxlintrc.json / oxlint.config.ts, or oxlint in package.json.
return {
    {
        "mason-org/mason.nvim",
        opts = {
            ensure_installed = { "oxlint" },
        },
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            ---@type table<string, vim.lsp.Config>
            servers = {
                oxlint = {
                    settings = {
                        run = "onType", -- lint as you type instead of only on save
                    },
                    keys = {
                        { "<leader>cO", "<cmd>LspOxlintFixAll<cr>", desc = "Fix all (oxlint)" },
                    },
                },
            },
        },
    },
}
