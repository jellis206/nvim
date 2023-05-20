return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = true,
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          never_show = {
            ".DS_Store"
          },
          always_show = { -- remains visible even if other settings would normally hide it
            ".gitignored",
            "node_modules"
          }
        }
      }
    }
  }
}
