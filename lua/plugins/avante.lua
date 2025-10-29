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

      mappings = {
        -- Core
        show_sidebar = "<leader>Aa",
        toggle = {
          default = "<leader>At",
          debug = "<leader>Ad",
          hint = "<leader>Ah",
          suggestion = "<leader>As",
          repomap = "<leader>AR",
        },
        refresh = "<leader>Ar",
        focus = "<leader>Af",

        -- Suggestion
        select_model = "<leader>A?",
        ask = "<leader>An",
        edit = "<leader>Ae",
        stop_request = "<leader>AS",
        select_histories = "<leader>Ah",

        -- Files
        files = {
          add_current = "<leader>Ac",
          add_all = "<leader>Ab",
        },
      },
    },

    keys = {
      { "<leader>A", "", desc = "+avante", mode = { "n", "v" } },

      -- Sidebar
      {
        "<leader>Aa",
        function()
          require("avante").show_sidebar()
        end,
        desc = "Show Sidebar",
      },
      {
        "<leader>At",
        function()
          require("avante").toggle()
        end,
        desc = "Toggle Sidebar",
      },
      {
        "<leader>Ar",
        function()
          require("avante").refresh()
        end,
        desc = "Refresh Sidebar",
      },
      {
        "<leader>Af",
        function()
          require("avante").focus()
        end,
        desc = "Focus Sidebar",
      },

      -- Toggles
      {
        "<leader>Ad",
        function()
          require("avante").toggle("debug")
        end,
        desc = "Toggle Debug",
      },
      {
        "<leader>Ah",
        function()
          require("avante").toggle("hint")
        end,
        desc = "Toggle Hint",
      },
      {
        "<leader>As",
        function()
          require("avante").toggle("suggestion")
        end,
        desc = "Toggle Suggestions",
      },
      {
        "<leader>AR",
        function()
          require("avante").toggle("repomap")
        end,
        desc = "Toggle Repomap",
      },

      -- Suggestions
      {
        "<leader>A?",
        function()
          require("avante").select_model()
        end,
        desc = "Select Model",
      },
      {
        "<leader>An",
        function()
          require("avante").ask()
        end,
        desc = "New Ask",
      },
      {
        "<leader>Ae",
        function()
          require("avante").edit()
        end,
        desc = "Edit Selection",
      },
      {
        "<leader>AS",
        function()
          require("avante").stop_request()
        end,
        desc = "Stop Request",
      },
      {
        "<leader>Ah",
        function()
          require("avante").select_histories()
        end,
        desc = "Select Chat History",
      },

      -- Files
      {
        "<leader>Ac",
        function()
          require("avante").add_current_file()
        end,
        desc = "Add Current File",
      },
      {
        "<leader>Ab",
        function()
          require("avante").add_all_buffers()
        end,
        desc = "Add All Buffers",
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
