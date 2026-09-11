local M = {}

local function open_prompt(title, on_submit)
    local width = math.min(72, math.floor(vim.o.columns * 0.6))
    local height = math.min(8, math.max(3, math.floor(vim.o.lines * 0.2)))
    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
        title = " " .. title .. " ",
        title_pos = "center",
    })

    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].filetype = "pi-nvim-prompt"
    vim.wo[win].wrap = true

    local function close()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
        if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end

    local function submit()
        local prompt = vim.trim(table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n"))
        close()
        on_submit(prompt)
    end

    local opts = { buffer = buf, silent = true }
    vim.keymap.set({ "i", "n" }, "<C-s>", submit, opts)
    vim.keymap.set("n", "q", close, opts)
    vim.keymap.set("n", "<Esc>", close, opts)

    vim.notify("Write your prompt, then press Ctrl-S to send", vim.log.levels.INFO)
    vim.cmd.startinsert()
end

local function selected_items(picker)
    return picker:selected({ fallback = true })
end

local function relative_path(path, cwd)
    local absolute = vim.fs.abspath(path)
    local relative = vim.fs.relpath(cwd, absolute)
    return relative or absolute
end

function M.send_files()
    local cwd = vim.uv.cwd()
    Snacks.picker.files({
        cwd = cwd,
        title = "Select files to send to Pi",
        confirm = function(picker)
            local items = selected_items(picker)
            picker:close()

            if #items == 0 then
                return
            end

            local paths = vim.tbl_map(function(item)
                return relative_path(item.file, cwd)
            end, items)

            open_prompt(
                string.format("Pi: %d file%s", #paths, #paths == 1 and "" or "s"),
                function(prompt)
                    local context = "Files:\n- " .. table.concat(paths, "\n- ")
                    local message = prompt == "" and context or prompt .. "\n\n" .. context
                    require("pi-nvim").prompt(message)
                end
            )
        end,
    })
end

function M.send_buffers()
    local cwd = vim.uv.cwd()
    Snacks.picker.buffers({
        title = "Select buffers to send to Pi",
        unloaded = false,
        confirm = function(picker)
            local items = selected_items(picker)
            picker:close()

            if #items == 0 then
                return
            end

            local snapshots = {}
            for _, item in ipairs(items) do
                local buf = item.buf
                if buf and vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
                    local name = vim.api.nvim_buf_get_name(buf)
                    local label = name == "" and string.format("[No Name %d]", buf)
                        or relative_path(name, cwd)
                    local filetype = vim.bo[buf].filetype
                    local content =
                        table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
                    table.insert(
                        snapshots,
                        string.format("Buffer: %s\n```%s\n%s\n```", label, filetype, content)
                    )
                end
            end

            if #snapshots == 0 then
                vim.notify("No loaded buffers selected", vim.log.levels.WARN)
                return
            end

            open_prompt(
                string.format("Pi: %d buffer%s", #snapshots, #snapshots == 1 and "" or "s"),
                function(prompt)
                    local context = table.concat(snapshots, "\n\n")
                    local message = prompt == "" and context or prompt .. "\n\n" .. context
                    require("pi-nvim").prompt(message)
                end
            )
        end,
    })
end

return M
