---@class Avante
---@field ask fun()
---@field edit fun()
---@field refresh fun()
---@field focus fun()
---@field toggle fun(mode?: string)
---@field add_current_file fun()
---@field add_all_buffers fun()
---@field select_model fun()
---@field stop_request fun()
---@field select_histories fun()
---@field show_sidebar fun()
return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change

    opts = {
      -- Set Claude as the default provider
      provider = "claude",

      -- Configure providers
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-haiku-4-5-20251001", -- Claude Haiku 3.5
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.7,
            max_tokens = 4096,
          },
        },
      },
    },

    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      -- "nvim-mini/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      -- "ibhagwan/fzf-lua", -- for file_selector provider fzf
      -- "stevearc/dressing.nvim", -- for input provider dressing
      "folke/snacks.nvim", -- for input provider snacks
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      -- "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
