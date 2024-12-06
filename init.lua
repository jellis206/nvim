-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Function to clear all registers
local function clear_registers()
  local registers = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"*+'
  for reg in registers:gmatch(".") do
    vim.fn.setreg(reg, "")
  end
  print("All registers cleared!")
end

-- Create a command to call the function
vim.api.nvim_create_user_command("ClearRegisters", clear_registers, {})
