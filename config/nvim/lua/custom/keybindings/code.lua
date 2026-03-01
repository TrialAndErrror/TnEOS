-- Code actions keybindings
local wk = require 'which-key'
local silicon = require 'silicon'

-- Register keybindings with which-key (using wk.add method)
wk.add {
  { '<leader>c', group = 'Code Actions' },
  { '<leader>ca', vim.lsp.buf.code_action, desc = 'Code action' },
  { '<leader>cr', vim.lsp.buf.rename, desc = 'Rename symbol' },
  {
    '<leader>cf',
    function()
      vim.lsp.buf.format { async = true }
    end,
    desc = 'Format buffer',
  },

  -- Add keybindings for silicon
  {
    '<leader>cs',
    function()
      silicon.visualise_api {}
    end,
    desc = 'Capture selection',
    mode = 'v',
  },
  {
    '<leader>cbs',
    function()
      silicon.visualise_api { to_clip = true, show_buf = true }
    end,
    desc = 'Capture buffer with selection',
    mode = 'v',
  },
}
