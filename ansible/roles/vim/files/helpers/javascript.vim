set tabstop=2
set shiftwidth=2
" Debugger expand for js files
iabbrev <buffer> d; debugger;
" Run tests with vimux using jest
map <buffer> <leader>rt :call VimuxRunCommand("clear; cd " . expand('%:p:h') . "; jest --watch --runInBand " . bufname("%"))<CR>

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
