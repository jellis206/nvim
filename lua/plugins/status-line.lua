local function get_default_colors()
  return { bg = "#1a1b26", fg = "#ffffff" }
end

local function get_colors(color)
  return { fg = Snacks.util.color(color) }
end

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local icons = LazyVim.config.icons

      vim.o.laststatus = vim.g.lualine_laststatus

      local opts = {
        options = {
          theme = "auto",
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              separator = { left = "", right = "" },
            },
          },
          lualine_b = { "branch" },
          lualine_c = {
            {
              function()
                -- Split the path and get the last 3 parts
                local function get_last_n_parts(path, n)
                  local parts = {}
                  for part in path:gmatch("[^/]+") do
                    table.insert(parts, part)
                  end
                  local start_index = math.max(#parts - n + 1, 1)
                  local result = {}
                  for i = start_index, #parts do
                    table.insert(result, parts[i])
                  end
                  return table.concat(result, "/")
                end
                local path = LazyVim.root()
                return get_last_n_parts(path, 3)
              end,
              icon = "󱉭",
              color = function()
                return get_colors("Special")
              end,
            },
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            {
              "filetype",
              icon_only = true,
              padding = { left = 1, right = 0 },
            },
            {
              LazyVim.lualine.pretty_path({ relative = "cwd" }),
            },
          },
          lualine_x = {
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              color = function()
                return get_colors("Statement")
              end,
            },
            {
              function()
                return "  " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
              color = function()
                return get_colors("Debug")
              end,
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
            -- {
            --   function()
            --     local msg = "No Active Lsp"
            --     local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
            --     local clients = vim.lsp.get_clients()
            --     if next(clients) == nil then
            --       return msg
            --     end
            --     for _, client in ipairs(clients) do
            --       local filetypes = client.config.filetypes
            --       if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            --         return client.name
            --       end
            --     end
            --     return msg
            --   end,
            --   icon = " LSP:",
            -- },
          },
          lualine_y = {
            { "progress", separator = { left = "" }, padding = { left = 1, right = 1 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            {
              function()
                return " " .. os.date("%R")
              end,
              separator = { left = "", right = "" },
              left_padding = 2,
            },
          },
        },
        extensions = { "neo-tree", "lazy" },
      }

      if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
        local trouble = require("trouble")
        local symbols = trouble.statusline({
          mode = "symbols",
          groups = {},
          title = false,
          filter = { range = true },
          format = "{kind_icon}{symbol.name:Normal}",
          hl_group = "lualine_c_normal",
        })
        table.insert(opts.sections.lualine_c, {
          symbols and symbols.get,
          cond = function()
            return vim.b.trouble_lualine ~= false and symbols.has()
          end,
          color = function()
            return get_colors("Error")
          end,
        })
      end

      return opts
    end,
  },
}
