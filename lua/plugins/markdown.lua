local plugin_dir = vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim"
local app_dir = plugin_dir .. "/app"

local function has_binary()
    return vim.fn.glob(app_dir .. "/bin/markdown-preview-*") ~= ""
end

local function has_node_modules()
    return vim.fn.isdirectory(app_dir .. "/node_modules") == 1
end

local function runnable()
    return has_binary() or has_node_modules()
end

-- mkdp's client rewrites the URL from /page/<bufnr> to /<bufnr> on load
-- (history.replaceState in pages/index.jsx). But the server only serves the app
-- for /page/\d+ paths, so reloading the bare /<bufnr> URL hits the 404 handler.
-- Re-prefix the rewrite with /page/ so the canonical URL stays reload-safe.
-- The served artifact is the compiled bundle under out/; the .jsx only matters if
-- rebuilt. lazy git-restores these on update, so this runs from the build hook and
-- at load to self-heal. Idempotent: only writes when the un-patched literal is present.
local function patch_reload_url()
    local function replace_in_file(path, find, repl)
        local f = io.open(path, "r")
        if not f then
            return
        end
        local content = f:read("*a")
        f:close()
        if not content:find(find, 1, true) then
            return
        end
        local out = (content:gsub(vim.pesc(find), (repl:gsub("%%", "%%%%"))))
        local w = io.open(path, "w")
        if not w then
            return
        end
        w:write(out)
        w:close()
    end

    for _, bundle in ipairs(vim.fn.glob(app_dir .. "/out/_next/static/*/pages/index.js", false, true)) do
        replace_in_file(bundle, 'replaceState(null,"","/".concat(e))', 'replaceState(null,"","/page/".concat(e))')
    end
    replace_in_file(
        app_dir .. "/pages/index.jsx",
        "window.history.replaceState(null, '', `/${bufnr}`)",
        "window.history.replaceState(null, '', `/page/${bufnr}`)"
    )
end

-- Sync install: used by lazy's `build` hook (lazy shows its own progress UI).
local function install_sync()
    vim.fn.system({ "bash", app_dir .. "/install.sh" })
    if has_binary() then
        return true
    end
    -- No pre-built binary for this arch (e.g. Linux aarch64). Fall back to
    -- populating node_modules; plugin's rpc.vim runs `node app/index.js` then.
    vim.fn.system({ "npm", "install", "--prefix", app_dir, "--no-audit", "--no-fund", "--loglevel=error" })
    return runnable()
end

-- Async install: used at plugin load when something's missing, so nvim doesn't block.
local function install_async()
    vim.notify("markdown-preview: installing (one-time)...", vim.log.levels.INFO)
    vim.fn.jobstart({ "bash", app_dir .. "/install.sh" }, {
        on_exit = function(_, code)
            if code == 0 and has_binary() then
                vim.notify("markdown-preview: ready", vim.log.levels.INFO)
                return
            end
            vim.fn.jobstart(
                { "npm", "install", "--prefix", app_dir, "--no-audit", "--no-fund", "--loglevel=error" },
                {
                    on_exit = function(_, npm_code)
                        if npm_code == 0 and runnable() then
                            vim.notify("markdown-preview: ready", vim.log.levels.INFO)
                        else
                            vim.notify(
                                "markdown-preview: install failed (npm exit " .. npm_code .. ")",
                                vim.log.levels.ERROR
                            )
                        end
                    end,
                }
            )
        end,
    })
end

return {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = "markdown",
        build = function()
            install_sync()
            patch_reload_url()
        end,
        keys = {
            {
                "<leader>pm",
                ft = "markdown",
                function()
                    if not runnable() then
                        vim.notify(
                            "markdown-preview: still installing, try again in a moment",
                            vim.log.levels.WARN
                        )
                        return
                    end
                    -- mkdp tracks open state per buffer in b:MarkdownPreviewToggleBool (0 or 1).
                    -- NB: 0 is truthy in Lua, so compare explicitly.
                    if vim.b.MarkdownPreviewToggleBool == 1 then
                        -- Close only THIS buffer's page (async rpcnotify), leaving the
                        -- shared server and any other open previews alone. The stock
                        -- toggle/stop tears down the whole server via a blocking rpcrequest.
                        vim.fn["mkdp#rpc#preview_close"]()
                        vim.notify("Markdown preview stopped", vim.log.levels.INFO, { title = "MarkdownPreview" })
                        return
                    end
                    -- mkdp runs ONE shared server for the whole nvim session; every buffer
                    -- is served on the same port at /page/<bufnr>. Only pick a port when no
                    -- server is up yet — otherwise reuse the running one (changing
                    -- g:mkdp_port mid-session is ignored and corrupts mkdp's state).
                    local server_up = vim.fn["mkdp#rpc#get_server_status"]() == 1
                    if not server_up then
                        local port_start = 8765
                        local port_count = 8
                        local function port_free(p)
                            local sock = vim.uv.new_tcp()
                            -- libuv's bind() doesn't surface EADDRINUSE; only listen() does
                            -- (same path the node server crashes on). Probe with listen so we
                            -- never hand a busy port to a sibling nvim session.
                            local bound = sock:bind("127.0.0.1", p) ~= nil
                            local free = bound and sock:listen(1, function() end) == 0
                            sock:close()
                            return free
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
                    end
                    vim.cmd("MarkdownPreviewToggle")
                    local url = ("http://localhost:%s/page/%d"):format(vim.g.mkdp_port, vim.fn.bufnr("%"))
                    vim.notify("Markdown preview: " .. url, vim.log.levels.INFO, { title = "MarkdownPreview" })
                end,
                desc = "Markdown Preview",
            },
            {
                "<leader>pk",
                ft = "markdown",
                "<cmd>MarkdownPreviewStop<cr>",
                desc = "Markdown Preview Kill (stop server)",
            },
        },
        config = function()
            vim.g.mkdp_auto_start = 0
            vim.g.mkdp_auto_close = 1
            vim.g.mkdp_open_to_the_world = 0
            -- mkdp tries to auto-launch a browser; suppress it when there's
            -- nowhere sensible for the browser to appear. SSH sessions count as
            -- headless even on macOS (open(1) over SSH would target whoever's
            -- logged into the console, not us).
            local in_ssh = vim.env.SSH_CONNECTION ~= nil or vim.env.SSH_TTY ~= nil
            local has_local_gui = not in_ssh
                and (
                    vim.fn.has("mac") == 1
                    or vim.env.DISPLAY ~= nil
                    or vim.env.WAYLAND_DISPLAY ~= nil
                )
            if not has_local_gui then
                vim.g.mkdp_browser = "true"
            end
            if not runnable() then
                install_async()
            end
            patch_reload_url()
            vim.cmd([[do FileType]])
        end,
    },
}
