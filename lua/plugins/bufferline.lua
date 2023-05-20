return {
  {
    "akinsho/bufferline.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    opts = {
      options = {
        separator_style = "slant",
        indicator = "underline",
        numbers = "ordinal",
        number_style = "superscript",
        mappings = true,
        buffer_close_icon = "",
        modified_icon = "",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 18,
        max_prefix_length = 15, -- prefix used when a buffer is deduplicated
        tab_size = 18,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local icons = require("lazyvim.config").icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        sort_by = "id",
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
      highlights = {
        fill = {
          fg = "<colour-value-here>",
          bg = "<colour-value-here>",
        },
        background = {
          fg = "<colour-value-here>",
          bg = "031627",
        },
        tab = {
          fg = "<colour-value-here>",
          bg = "<colour-value-here>",
        },
        tab_selected = {
          fg = "<colour-value-here>",
          bg = "<colour-value-here>",
        },
      },
    },
  },
}
