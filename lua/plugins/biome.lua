-- Biome format for repos that actually use it (Bonaparte: biome.json).
-- Matches CI `pnpm format:check`: formatter + assist, linter off.
-- Repos without biome.json keep oxfmt / prettier.

local biome_markers = { "biome.json", "biome.jsonc" }

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

local BIOME_FTS = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "json",
  "jsonc",
  "css",
  "yaml",
}

return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "biome" },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      local util = require("conform.util")
      opts.formatters = opts.formatters or {}
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.format = vim.tbl_deep_extend("force", opts.format or {}, {
        stop_after_first = true,
      })

      opts.formatters.biome = vim.tbl_deep_extend("force", opts.formatters.biome or {}, {
        command = util.from_node_modules("biome"),
        args = {
          "check",
          "--write",
          "--linter-enabled=false",
          "--formatter-enabled=true",
          "--assist-enabled=true",
          "--stdin-file-path",
          "$FILENAME",
        },
        stdin = true,
        cwd = util.root_file(biome_markers),
        require_cwd = true,
        condition = function(_, ctx)
          return uses_biome(ctx)
        end,
      })

      for _, ft in ipairs(BIOME_FTS) do
        local existing = opts.formatters_by_ft[ft] or {}
        if existing[1] ~= "biome" then
          opts.formatters_by_ft[ft] = { "biome", unpack(existing) }
        end
      end
    end,
  },
}
