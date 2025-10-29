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
        show_sidebar = "<leader>aa",
        toggle = {
          default = "<leader>at",
          debug = "<leader>ad",
          hint = "<leader>ah",
          suggestion = "<leader>as",
          repomap = "<leader>aR",
        },
        refresh = "<leader>ar",
        focus = "<leader>af",

        -- Suggestion
        select_model = "<leader>a?",
        ask = "<leader>an",
        edit = "<leader>ae",
        stop_request = "<leader>aS",
        select_histories = "<leader>ah",

        -- Files
        files = {
          add_current = "<leader>ac",
          add_all = "<leader>ab",
        },
      },
    },

    keys = {
      { "<leader>a", "", desc = "+avante", mode = { "n", "v" } },

      -- Sidebar
      {
        "<leader>aa",
        function()
          require("avante").show_sidebar()
        end,
        desc = "Show Sidebar",
      },
      {
        "<leader>at",
        function()
          require("avante").toggle()
        end,
        desc = "Toggle Sidebar",
      },
      {
        "<leader>ar",
        function()
          require("avante").refresh()
        end,
        desc = "Refresh Sidebar",
      },
      {
        "<leader>af",
        function()
          require("avante").focus()
        end,
        desc = "Focus Sidebar",
      },

      -- Toggles
      {
        "<leader>ad",
        function()
          require("avante").toggle("debug")
        end,
        desc = "Toggle Debug",
      },
      {
        "<leader>ah",
        function()
          require("avante").toggle("hint")
        end,
        desc = "Toggle Hint",
      },
      {
        "<leader>as",
        function()
          require("avante").toggle("suggestion")
        end,
        desc = "Toggle Suggestions",
      },
      {
        "<leader>aR",
        function()
          require("avante").toggle("repomap")
        end,
        desc = "Toggle Repomap",
      },

      -- Suggestions
      {
        "<leader>a?",
        function()
          require("avante").select_model()
        end,
        desc = "Select Model",
      },
      {
        "<leader>an",
        function()
          require("avante").ask()
        end,
        desc = "New Ask",
      },
      {
        "<leader>ae",
        function()
          require("avante").edit()
        end,
        desc = "Edit Selection",
      },
      {
        "<leader>aS",
        function()
          require("avante").stop_request()
        end,
        desc = "Stop Request",
      },
      {
        "<leader>ah",
        function()
          require("avante").select_histories()
        end,
        desc = "Select Chat History",
      },

      -- Files
      {
        "<leader>ac",
        function()
          require("avante").add_current_file()
        end,
        desc = "Add Current File",
      },
      {
        "<leader>ab",
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
