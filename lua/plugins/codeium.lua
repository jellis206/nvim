return {
  {
    'Exafunction/codeium.vim',
    config = function ()
      -- Change '<C-g>' here to any keycode you like.
      vim.keymap.set('i', '<S-d>', function () return vim.fn['codeium#Accept']() end, { expr = true })
      vim.keymap.set('i', '<S-w>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
      vim.keymap.set('i', '<S-s>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
      vim.keymap.set('i', '<S-a>', function() return vim.fn['codeium#Clear']() end, { expr = true })
    end
  },
}