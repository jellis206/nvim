-- oxlint + oxfmt for projects that actually use them.
-- Repos without oxfmt keep LazyVim's prettier / eslint extras as the fallback.
-- (The home ~/.prettierrc makes prettier think every file has a config.)
local oxfmt_markers = { ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" }
local biome_markers = { "biome.json", "biome.jsonc" }

---@param ctx { filename?: string, dirname?: string }
local function uses_oxfmt(ctx)
  local path = ctx.dirname
  if (not path or path == "") and ctx.filename then
    path = vim.fn.fnamemodify(ctx.filename, ":h")
  end
  if not path or path == "" then
    return false
  end

  local found = vim.fs.find(oxfmt_markers, { path = path, upward = true, limit = 1 })[1]
  if found and vim.fs.dirname(found) ~= vim.uv.os_homedir() then
    return true
  end

  local home = vim.uv.os_homedir()
  for _, pkg in ipairs(vim.fs.find("package.json", { path = path, upward = true, limit = 8 })) do
    if vim.fs.dirname(pkg) == home then
      break
    end
    local ok, data = pcall(function()
      return vim.json.decode(table.concat(vim.fn.readfile(pkg), "\n"))
    end)
    if ok and type(data) == "table" then
      for _, key in ipairs({ "dependencies", "devDependencies", "optionalDependencies" }) do
        if type(data[key]) == "table" and data[key].oxfmt then
          return true
        end
      end
    end
  end

  return false
end

---@param ctx { filename?: string, dirname?: string }
local function uses_biome(ctx)
  local path = ctx.dirname
  if (not path or path == "") and ctx.filename then
    path = vim.fn.fnamemodify(ctx.filename, ":h")
  end
  if not path or path == "" then
    return false
  end

  local found = vim.fs.find(biome_markers, { path = path, upward = true, limit = 1 })[1]
  return found ~= nil and vim.fs.dirname(found) ~= vim.uv.os_homedir()
end

-- Some repos lint test files with a second oxlint config (bonaparte uses
-- .oxlintrc.tests.json, which turns correctness off and enables a short
-- allowlist). The language server only accepts one config per workspace, so it
-- reports production-only rules on test files that CI never runs there. Drop
-- those client-side so the editor agrees with CI.
local TEST_CONFIG = ".oxlintrc.tests.json"
local test_rules_cache = {}

local function is_test_file(path)
  return path:match("%.test%.[jt]sx?$") ~= nil or path:match("%.spec%.[jt]sx?$") ~= nil
end

--- Rules enabled by the nearest test config, or nil when the repo has none.
local function allowed_test_rules(path)
  local found = vim.fs.find(TEST_CONFIG, { path = vim.fs.dirname(path), upward = true, limit = 1 })[1]
  if not found then
    return nil
  end
  if test_rules_cache[found] then
    return test_rules_cache[found]
  end

  local rules = {}
  local ok, data = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(found), "\n"))
  end)
  if ok and type(data) == "table" and type(data.rules) == "table" then
    for name, setting in pairs(data.rules) do
      local level = type(setting) == "table" and setting[1] or setting
      if level ~= "off" then
        rules[name] = true
      end
    end
  end

  test_rules_cache[found] = rules
  return rules
end

-- oxlint reports `@tooling/custom(no-module-mocking)`; configs key it as
-- `@tooling/custom/no-module-mocking`.
local function rule_name(diagnostic)
  if diagnostic.code == nil then
    return nil
  end
  local code = tostring(diagnostic.code)
  local plugin, rule = code:match("^(.+)%((.+)%)$")
  return plugin and (plugin .. "/" .. rule) or code
end

local function filter_test_diagnostics(result)
  if not (result and result.uri and result.diagnostics) then
    return
  end
  local path = vim.uri_to_fname(result.uri)
  if not is_test_file(path) then
    return
  end
  local allowed = allowed_test_rules(path)
  if not allowed then
    return
  end

  local kept = {}
  for _, diagnostic in ipairs(result.diagnostics) do
    local name = rule_name(diagnostic)
    -- Keep anything we cannot identify rather than hide it.
    if name == nil or allowed[name] then
      table.insert(kept, diagnostic)
    end
  end
  result.diagnostics = kept
end

return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "oxlint", "oxfmt" },
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
          handlers = {
            ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
              filter_test_diagnostics(result)
              return vim.lsp.handlers["textDocument/publishDiagnostics"](err, result, ctx, config)
            end,
          },
          keys = {
            { "<leader>cO", "<cmd>LspOxlintFixAll<cr>", desc = "Fix all (oxlint)" },
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters = opts.formatters or {}

      -- Don't treat every Vite repo as an oxfmt project (upstream cwd includes vite.config.*).
      opts.formatters.oxfmt = vim.tbl_deep_extend("force", opts.formatters.oxfmt or {}, {
        cwd = require("conform.util").root_file(oxfmt_markers),
        require_cwd = true,
        condition = function(_, ctx)
          return uses_oxfmt(ctx)
        end,
      })

      -- Prettier extra always runs for TS/JS, and ~/.prettierrc counts as a config.
      opts.formatters.prettier = vim.tbl_deep_extend("force", opts.formatters.prettier or {}, {
        condition = function(_, ctx)
          return not uses_oxfmt(ctx) and not uses_biome(ctx)
        end,
      })
    end,
  },
}
