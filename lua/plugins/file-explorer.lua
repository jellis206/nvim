return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.filesystem, {
        filesystem = {
          -- renderers = {
          --   directory = {
                -- custom icon stuff
          --   },
          -- },
          bind_to_cwd = false,
          follow_current_file = true,
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            always_show = { -- remains visible even if other settings would normally hide it
              ".gitignored",
              "node_modules",
            },
          },
        },
      })
    end,
  },
}