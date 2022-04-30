" Debugger expand for js files
iabbrev <buffer> d; debugger;

let g:test#javascript#runner = 'jest'
let g:test#javascript#jest#file_pattern = '\v(__tests__/.*|(spec|test|integration))\.(js|jsx|ts|tsx)$'
let g:test#javascript#jest#options = '--testMatch "**/__tests__/**/*.[jt]s?(x)", "**/?(*.)+(spec|test|integration).[jt]s?(x)"'

" Run node scripts
noremap <expr> <leader>rr  ':call VimuxRunCommand("node ' . expand("%:p") . ' ")<left><left>'
noremap <expr> <leader>ri  ':call VimuxRunCommand("node --inspect' . expand("%:p") . ' ")<left><left>'

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
