-- start screen
return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function(_, opts)
      local dashboard = require("alpha.themes.dashboard")
      local logo = [[
     ██╗███████╗██╗     ██╗     ██╗███████╗██████╗ 
     ██║██╔════╝██║     ██║     ██║██╔════╝╚════██╗
     ██║█████╗  ██║     ██║     ██║███████╗  ▄███╔╝
██   ██║██╔══╝  ██║     ██║     ██║╚════██║  ▀▀══╝ 
╚█████╔╝███████╗███████╗███████╗██║███████║  ██╗   
 ╚════╝ ╚══════╝╚══════╝╚══════╝╚═╝╚══════╝  ╚═╝
 ]]
      dashboard.section.header.val = vim.split(logo, "\n")
    end,
  },
}