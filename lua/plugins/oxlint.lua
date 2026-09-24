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
