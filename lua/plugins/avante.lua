-- Avante config for a git-shared Neovim setup across multiple machines.
--
-- This file is read on boot and populates avante's provider table from
-- ~/.ai_models.json, so each machine adapts to whatever local model servers it
-- actually runs. The default provider is chosen by an auto fallback chain:
--
--   1. Claude subscription (OAuth / "teams license")  -- if logged in
--   2. First locally-running model from ~/.ai_models.json
--   3. Claude API key (ANTHROPIC_API_KEY)             -- only if no local models
--
-- Claude stays available either way: if you have an API key but aren't logged
-- in with the subscription, the API-key Claude provider is still configured --
-- it's just not the default. Switch to it manually with <leader>ap (provider)
-- or <leader>am (model).
--
-- Check what's live on the current machine with :AvanteWhoami.
-- Log in with your subscription once with :AvanteLoginMax (opens a browser).

local uv = vim.uv or vim.loop

-- Per-machine manifest of locally-running, OpenAI-compatible model servers.
local AI_MODELS_JSON = vim.fn.expand("~/.ai_models.json")

-- Where avante stores the Claude subscription (OAuth) token once logged in.
-- Its presence is our signal that a "teams license" is available here.
local CLAUDE_OAUTH_TOKEN = vim.fn.stdpath("data") .. "/avante/claude-auth.json"

-- Read + decode ~/.ai_models.json. Returns the `providers` table, or {} on any
-- problem (missing file, bad JSON) so a server-less machine degrades cleanly.
local function read_local_manifest()
    local fd = io.open(AI_MODELS_JSON, "r")
    if not fd then
        return {}
    end
    local raw = fd:read("*a")
    fd:close()
    local ok, decoded = pcall(vim.json.decode, raw)
    if not ok or type(decoded) ~= "table" then
        return {}
    end
    return decoded.providers or {}
end

-- Turn the manifest into avante providers (OpenAI-compatible). Each JSON
-- provider becomes one avante provider named exactly as in the file.
-- Returns (providers_table, first_provider_name) -- first is the local default.
local function build_local_providers()
    local providers = {}
    local first_name = nil

    local manifest = read_local_manifest()
    -- Sort keys so "first" is deterministic across boots and machines.
    local names = vim.tbl_keys(manifest)
    table.sort(names)

    for _, name in ipairs(names) do
        local p = manifest[name]
        local model_names = {}
        for _, m in ipairs(p.models or {}) do
            if m.id then
                table.insert(model_names, m.id)
            end
        end

        if p.baseUrl and #model_names > 0 then
            first_name = first_name or name
            providers[name] = {
                __inherited_from = "openai",
                -- OpenAI-compatible servers expect the /v1 base; avante appends
                -- /chat/completions and /models itself. Trailing slashes trimmed first.
                endpoint = (p.baseUrl:gsub("/+$", "")) .. "/v1",
                -- Static key straight from the manifest -- no env-var pollution.
                -- `cmd:` makes avante treat the key as always-set (no prompt).
                api_key_name = p.apiKey and ("cmd:echo " .. p.apiKey) or "",
                model = model_names[1], -- default = first listed model
                model_names = model_names, -- <leader>am lists them all, no network call
                timeout = 60000, -- local servers can be slow to first token
            }
        end
    end

    return providers, first_name
end

-- Which Claude auth is available on THIS machine?
--   "oauth" -> subscription token present (the "teams license")
--   "api"   -> ANTHROPIC_API_KEY is set
--   nil     -> neither; caller falls back to a local model
local function detect_claude_auth()
    if uv.fs_stat(CLAUDE_OAUTH_TOKEN) then
        return "oauth"
    end
    local key = os.getenv("ANTHROPIC_API_KEY")
    if key and key ~= "" then
        return "api"
    end
    return nil
end

-- ---------------------------------------------------------------------------
-- Workaround for an upstream avante bug (present in every version, incl. v0.1.2)
-- that breaks EVERY agentic turn the moment a tool is called with empty args.
--
-- Lua can't tell an empty object from an empty array, so avante's history
-- reconstruction serializes an empty tool input `{}` as JSON `[]`, and both
-- APIs reject it:
--   Anthropic: "tool_use.input: Input should be an object"
--   OpenAI:    "tool_calls: arguments must be a JSON object, got list"
-- The same code path also occasionally emits messages with no `role`.
--
-- We fix it at the last possible moment by wrapping each provider's
-- parse_curl_args and repairing the request body just before it is encoded.
-- This lives here (not in the plugin dir) so it survives :Lazy update.
local function repair_request_body(messages)
    if type(messages) ~= "table" then
        return
    end
    for _, msg in ipairs(messages) do
        -- OpenAI chat format: every message needs a role.
        if type(msg) == "table" and msg.role == nil then
            if msg.tool_calls then
                msg.role = "assistant"
            elseif msg.tool_call_id then
                msg.role = "tool"
            else
                msg.role = "user"
            end
        end
        -- OpenAI: tool-call arguments are a pre-encoded string; "[]"/empty -> "{}".
        if type(msg) == "table" and type(msg.tool_calls) == "table" then
            for _, tc in ipairs(msg.tool_calls) do
                local fn = tc["function"]
                if fn and (fn.arguments == nil or fn.arguments == "" or fn.arguments == "[]") then
                    fn.arguments = "{}"
                end
            end
        end
        -- Anthropic: content is a list of blocks; empty tool_use.input -> empty object.
        if type(msg) == "table" and type(msg.content) == "table" then
            for _, item in ipairs(msg.content) do
                if type(item) == "table" and item.type == "tool_use" then
                    if type(item.input) ~= "table" or vim.tbl_isempty(item.input) then
                        item.input = vim.empty_dict()
                    end
                end
            end
        end
    end
end

-- Wrap the parse_curl_args of the given provider modules (idempotent). Run at
-- load time, before any request instantiates a provider, so the fixed function
-- is the one copied onto each provider (including openai-inherited local ones).
local function patch_tool_serialization()
    for _, name in ipairs({ "claude", "openai" }) do
        local ok, mod = pcall(require, "avante.providers." .. name)
        if ok and type(mod) == "table" and not mod.__l2l_toolfix then
            local orig = mod.parse_curl_args
            if type(orig) == "function" then
                mod.parse_curl_args = function(self, prompt_opts)
                    local args = orig(self, prompt_opts)
                    if type(args) == "table" and type(args.body) == "table" then
                        repair_request_body(args.body.messages)
                    end
                    return args
                end
                mod.__l2l_toolfix = true
            end
        end
    end
end

return {
    {
        "yetone/avante.nvim",
        -- LazyVim's avante extra registers <leader>aa/<leader>ae as normal-mode
        -- ONLY, so a visual selection is never captured. Re-map them for visual
        -- mode too; `<cmd>` preserves visual mode, so avante's ask()/edit() see
        -- the live selection (it reads getpos("v")/(".") and bails if not in
        -- visual mode).
        keys = {
            { "<leader>aa", "<cmd>AvanteAsk<cr>", mode = { "n", "v" }, desc = "Ask Avante" },
            { "<leader>ac", "<cmd>AvanteChat<cr>", mode = { "n", "v" }, desc = "Chat with Avante" },
            { "<leader>ae", "<cmd>AvanteEdit<cr>", mode = { "n", "v" }, desc = "Edit Avante" },
        },
        opts = function(_, opts)
            -- Startup guard: avante needs a native build (avante_templates.so et al.)
            -- that lives in the per-machine plugin dir, NOT in this git-shared config.
            -- If it's absent, surface the one-line fix now instead of the cryptic
            -- "missing avante_templates" stack trace the first time you open the sidebar.
            if not pcall(require, "avante_templates") then
                vim.schedule(function()
                    vim.notify(
                        "avante is not built on this machine.\nRun  :Lazy build avante.nvim  to fix.",
                        vim.log.levels.WARN,
                        { title = "Avante" }
                    )
                end)
            end

            -- Repair avante's empty-tool-arg serialization bug (see above).
            patch_tool_serialization()

            opts.providers = opts.providers or {}

            -- 1. Register every locally-running model server from the manifest.
            local local_providers, first_local = build_local_providers()
            for name, cfg in pairs(local_providers) do
                opts.providers[name] = cfg
            end

            -- 2. Configure the Claude provider for whichever auth exists here.
            local claude_auth = detect_claude_auth()
            opts.providers.claude = vim.tbl_deep_extend("force", opts.providers.claude or {}, {
                -- "max" = subscription OAuth; "api" = ANTHROPIC_API_KEY.
                -- Falls back to "api" as a harmless default when neither is present.
                auth_type = claude_auth == "oauth" and "max" or "api",
            })

            -- 3. Pick the default provider via the fallback chain.
            --    Prefer the subscription (teams license) when authed; otherwise
            --    default to a LOCAL model. The API-key Claude provider stays
            --    configured and selectable, it's just not the default -- so you
            --    only spend API tokens when you deliberately switch to it.
            --    Fall back to API-key Claude only when no local models exist.
            --    Override on any machine by setting `vim.g.avante_provider`.
            if vim.g.avante_provider then
                opts.provider = vim.g.avante_provider
            elseif claude_auth == "oauth" then
                opts.provider = "claude"
            elseif first_local then
                opts.provider = first_local
            elseif claude_auth == "api" then
                opts.provider = "claude"
            end
            -- (If nothing matched, avante keeps LazyVim's default provider.)

            -- :AvanteWhoami -- report what's actually live on this machine.
            vim.api.nvim_create_user_command("AvanteWhoami", function()
                local Config = require("avante.config")
                local prov = Config.provider
                local pcfg = Config.providers[prov] or {}
                local lines = { "Avante provider: " .. tostring(prov) }
                if prov == "claude" then
                    local mode = pcfg.auth_type == "max" and "subscription OAuth (teams license)"
                        or "API key (ANTHROPIC_API_KEY)"
                    table.insert(lines, "  auth: " .. mode)
                    table.insert(
                        lines,
                        "  teams license active: " .. tostring(detect_claude_auth() == "oauth")
                    )
                else
                    table.insert(lines, "  local model: " .. tostring(pcfg.model))
                    table.insert(lines, "  endpoint: " .. tostring(pcfg.endpoint))
                end
                vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "Avante" })
            end, { desc = "Show which Avante provider/auth is active" })

            -- :AvanteLoginMax -- one-time subscription login (opens a browser).
            -- After this succeeds the OAuth token exists and Auto prefers it on boot.
            vim.api.nvim_create_user_command("AvanteLoginMax", function()
                local claude = require("avante.providers.claude")
                require("avante.config").provider = "claude"
                require("avante.config").providers.claude.auth_type = "max"
                claude.authenticate()
                vim.notify(
                    "Follow the browser prompt, then restart or run :AvanteRefresh",
                    vim.log.levels.INFO,
                    {
                        title = "Avante",
                    }
                )
            end, { desc = "Log in to Claude with your subscription (OAuth)" })

            return opts
        end,
    },
}
