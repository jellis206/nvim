return {
  --{
  --"L3MON4D3/LuaSnip",
  --keys = function()
  --return {}
  --end,
  --},
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp_enabled = true
      vim.api.nvim_create_user_command("ToggleAutoComplete", function()
        if cmp_enabled then
          require("cmp").setup.buffer({ enabled = false })
          cmp_enabled = false
        else
          require("cmp").setup.buffer({ enabled = true })
          cmp_enabled = true
        end
      end, {})
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      local select_next = function()
        if cmp.visible() then
          return cmp.confirm({ select = true })
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
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

      local close_cmp = function()
        if cmp.visible() then
          cmp.close()
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
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Replace }),
        ["<C-b>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Replace }),
        ["<C-i>"] = cmp.mapping(function()
          cmp.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace })
        end, {
          "i",
          "s",
        }),
        ["<C-d>"] = cmp.mapping.abort(),
        ["<C-u>"] = cmp.mapping(function()
          close_cmp()
        end, { "i", "s" }),
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
