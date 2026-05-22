return {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = function()
            require("lazy").load({ plugins = { "markdown-preview.nvim" } })
            vim.fn["mkdp#util#install"]()
        end,
        keys = {
            {
                "<leader>pm",
                ft = "markdown",
                function()
                    local port_start = 8765
                    local port_count = 8
                    local function port_free(p)
                        local sock = vim.uv.new_tcp()
                        local ok = sock:bind("127.0.0.1", p)
                        sock:close()
                        return ok ~= nil
                    end
                    local chosen
                    for p = port_start, port_start + port_count - 1 do
                        if port_free(p) then
                            chosen = p
                            break
                        end
                    end
                    if not chosen then
                        vim.notify(
                            ("All %d markdown-preview ports (%d-%d) are busy"):format(
                                port_count,
                                port_start,
                                port_start + port_count - 1
                            ),
                            vim.log.levels.ERROR
                        )
                        return
                    end
                    vim.g.mkdp_port = tostring(chosen)
                    local url = ("http://localhost:%d/page/%d"):format(chosen, vim.fn.bufnr("%"))
                    vim.cmd("MarkdownPreviewToggle")
                    vim.notify("Markdown preview: " .. url, vim.log.levels.INFO, { title = "MarkdownPreview" })
                end,
                desc = "Markdown Preview",
            },
        },
        config = function()
            vim.g.mkdp_auto_start = 0
            vim.g.mkdp_auto_close = 1
            vim.g.mkdp_open_to_the_world = 0
            vim.g.mkdp_browser = "true" -- /bin/true: no-op, headless VM has no browser
            vim.cmd([[do FileType]])
        end,
    },
}
