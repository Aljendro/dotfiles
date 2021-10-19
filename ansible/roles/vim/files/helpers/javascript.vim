" Debugger expand for js files
iabbrev <buffer> d; debugger;

let g:test#javascript#runner = 'jest'

" Run node scripts
noremap <expr> <leader>rr  ':call VimuxRunCommand("node ' . expand("%:p") . ' ")<left><left>'
noremap <expr> <leader>ri  ':call VimuxRunCommand("node --inspect' . expand("%:p") . ' ")<left><left>'
noremap <expr> <leader>rbb ':call VimuxRunCommand("babel-node ' . expand("%:p") . ' ")<left><left>'
noremap <expr> <leader>rbi ':call VimuxRunCommand("babel-node --inspect ' . expand("%:p") . ' ")<left><left>'

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
