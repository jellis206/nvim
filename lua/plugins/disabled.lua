local plugins = {}

local sysname = vim.loop.os_uname().sysname
local is_linux = sysname == "Linux"
local is_ssh = os.getenv("SSH_CONNECTION") ~= nil

-- Disable img-clip.nvim when SSH'd into a Linux machine
if is_linux and is_ssh then
  table.insert(plugins, { "HakonHarnes/img-clip.nvim", enabled = false })
end

return plugins
