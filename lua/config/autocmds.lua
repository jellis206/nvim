-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local has_run_setup = false

local function after_all_setup()
  if not has_run_setup then
    vim.schedule(function()
      local copilot = require("copilot.command")
      if not require("copilot.client").is_disabled() then
        copilot.disable()
      end
      has_run_setup = true
    end)
  end
end

vim.api.nvim_create_augroup("AfterAllSetup", { clear = true })

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = "AfterAllSetup",
  callback = after_all_setup,
})
