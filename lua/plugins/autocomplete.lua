return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
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
        ["<Tab>"] = cmp.config.disable,
        ["<S-Tab>"] = cmp.config.disable,
        ["<C-i>"] = cmp.mapping(function()
          select_item()
        end, {
          "i",
          "s",
        }),
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
    end,
  },
}
