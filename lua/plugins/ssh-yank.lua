-- Enable dual clipboard sync (VM + Mac) when SSH'd into Linux.
local is_ssh = os.getenv("SSH_CONNECTION") ~= nil
local is_linux = vim.loop.os_uname().sysname == "Linux"

if not (is_ssh and is_linux) then
  return {}
end

return {
  "ojroques/nvim-osc52",
  event = "VeryLazy",
  config = function()
    local osc52 = require("osc52")

    -- Use system clipboard for regular yanks inside VM
    vim.opt.clipboard = "unnamedplus"

    -- Helper: copy text to both OSC52 (Mac) and VM clipboard (xclip)
    local function dual_copy(register)
      local reg = register == "" and '"' or register
      local ok, contents = pcall(vim.fn.getreg, reg)
      if not ok or contents == "" then
        return
      end

      -- 1. Copy to Mac clipboard via OSC52
      osc52.copy_register(reg)

      -- 2. Copy to VM clipboard via xclip (runs async)
      vim.fn.jobstart({ "xclip", "-selection", "clipboard" }, {
        stdin = contents,
        detach = true,
      })
    end

    -- Automatically run after every yank
    vim.api.nvim_create_autocmd("TextYankPost", {
      callback = function()
        if vim.v.event.operator == "y" then
          dual_copy(vim.v.event.regname)
        end
      end,
    })

    vim.notify("Dual clipboard sync enabled (OSC52 + xclip)", vim.log.levels.INFO)
  end,
}
