return {
  {
    "L3MON4D3/LuaSnip",
    opts = {
      history = true,
      delete_check_events = "TextChanged",
      updateevents = "TextChanged,TextChangedI",
      enable_autosnippets = true,
    },
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        local ls = require("luasnip")
        ls.filetype_extend("html", { "html", "angular" })
        ls.filetype_extend("typescript", { "angular", "typescript", "tsdoc" })
        ls.filetype_extend("sass", { "sass" })
        ls.filetype_extend("scss", { "scss" })
        ls.filetype_extend("css", { "css" })
        ls.filetype_extend("rust", { "rust", "rustdoc" })
        ls.filetype_extend("lua", { "lua", "luadoc" })
        ls.filetype_extend("c", { "c", "cdoc" })
        ls.filetype_extend("cpp", { "cpp", "cppdoc" })
        ls.filetype_extend("python", { "python", "pydoc" })
        ls.filetype_extend("javascript", { "javascript", "jsdoc" })
        ls.filetype_extend("go", { "go" })
        ls.filetype_extend("ruby", { "ruby", "rdoc", "rails" })
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
  },
}
