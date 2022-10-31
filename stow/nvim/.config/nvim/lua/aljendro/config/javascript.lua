
vim.cmd([[

" Debugger expand for js files
iabbrev <buffer> d; debugger;

]])

vim.g['test#javascript#runner'] = 'jest'
vim.g['test#javascript#jest#file_pattern'] = [[\v(__tests__/.*|(spec|test|integration))\.(js|jsx|ts|tsx)$]]
vim.g['test#javascript#jest#options'] = '--testMatch "**/__tests__/**/*.[jt]s?(x)", "**/?(*.)+(spec|test|integration).[jt]s?(x)"'

-- Run node scripts
vim.api.nvim_set_keymap('n', '<leader>rr', [[':call VimuxRunCommand("node ' . expand("%:p") . ' ")<left><left>']], { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>ri', [[':call VimuxRunCommand("node --inspect' . expand("%:p") . ' ")<left><left>']], { noremap = true })

vim.opt_local.foldmethod = 'expr'
vim.opt_local.foldexpr = vim.g['nvim_treesitter#foldexpr()']
