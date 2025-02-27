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

-- Enable termguicolors for true color support
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end

-- Prevent ^[[27u from being interpreted as 7u in Neovim
-- Remap the ESC key to the actual ESC key in the command mode
vim.cmd([[
  cnoremap <Esc> <Esc>
]])

-- Make block cursor blink
vim.opt.guicursor = "n-v-c:block-blinkwait175-blinkoff150-blinkon175,i-ci-ve:ver25-blinkwait175-blinkoff150-blinkon175"

-- Make sure the correct python interpreter is used
vim.g.python3_host_prog = "/Users/jellis/.asdf/installs/python/3.12.8/bin/python3"

-- I don't use perl so...
vim.g.loaded_perl_provider = 0
