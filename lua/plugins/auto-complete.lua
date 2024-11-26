return {
  {
    "nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local luasnip = require("luasnip")
      local cmp = require("cmp")

      local cmp_enabled = true
      vim.api.nvim_create_user_command("ToggleAutoComplete", function()
        if cmp_enabled then
          cmp.setup.buffer({ enabled = false })
          cmp_enabled = false
        else
          cmp.setup.buffer({ enabled = true })
          cmp_enabled = true
        end
      end, {})

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local select_item = function()
        local entry = cmp.get_selected_entry()

        if entry.source.name == "Luasnip" then
          if entry.source:is_available() then
            cmp.confirm({ select = true })
          else
            luasnip.expand_or_jump()
          end
        else
          cmp.confirm({ select = true })
        end
      end

      local select_next = function()
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          return
        end
      end

      local select_prev = function()
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          return
        end
      end

      local scroll_docs = function(scrollNum)
        if cmp.visible() then
          cmp.scroll(scrollNum)
        else
          return
        end
      end

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<CR>"] = cmp.config.disable,
        ["<S-Tab>"] = cmp.config.disable,
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            select_item()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end),
        ["<C-i>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            select_item()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end),
        ["<C-n>"] = cmp.mapping(function()
          select_next()
        end, { "i", "s" }),
        ["<C-b>"] = cmp.mapping(function()
          select_prev()
        end, { "i", "s" }),
        ["<C-u>"] = cmp.mapping.abort(),
        ["<C-j>"] = cmp.mapping(function()
          scroll_docs(4)
        end, { "i", "s" }),
        ["<C-k>"] = cmp.mapping(function()
          scroll_docs(-4)
        end, { "i", "s" }),
      })

      -- table.insert(opts.sources, 1, { name = "supermaven", group_index = 1, priority = 100 })

      -- opts.formatting.format = function(_, item)
      --   local icons = LazyVim.config.icons.kinds
      --   icons["Supermaven"] = " "
      --   if icons[item.kind] then
      --     item.kind = icons[item.kind] .. item.kind
      --   end

      --   local widths = {
      --     abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
      --     menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
      --   }

      --   for key, width in pairs(widths) do
      --     if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
      --       item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
      --     end
      --   end

      --   return item
      -- end
    end,
  },
}
