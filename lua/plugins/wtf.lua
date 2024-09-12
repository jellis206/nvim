return {
  "piersolenski/wtf.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lualine/lualine.nvim", -- Add lualine as a dependency
  },
  opts = {
    -- Default AI popup type
    popup_type = "popup",
    -- An alternative way to set your API key
    openai_api_key = os.getenv("OPENAI_API_KEY"),
    -- ChatGPT Model
    openai_model_id = "gpt-4o",
    -- Send code as well as diagnostics
    context = true,
    -- Set your preferred language for the response
    language = "english",
    -- Any additional instructions
    additional_instructions = nil,
    -- Default search engine, can be overridden by passing an option to WtfSearch
    search_engine = "google",
    -- Add custom colours
    winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
  },
  keys = {
    {
      "<leader>cw",
      mode = { "n", "x" },
      function()
        require("wtf").ai()
      end,
      desc = "Debug diagnostic with AI",
    },
    {
      mode = { "n" },
      "<leader>cW",
      function()
        require("wtf").search()
      end,
      desc = "Search diagnostic with Google",
    },
  },
  config = function()
    local wtf = require("wtf")
    require("lualine").setup({
      sections = {
        lualine_x = { wtf.get_status },
      },
    })
  end,
}
