set tabstop=2
set shiftwidth=2
" User prettier
nnoremap <buffer> <leader>pp :CocCommand prettier.formatFile<cr>
" Debugger expand for js files
iabbrev <buffer> d; debugger;
" Run tests with vimux using jest
map <buffer> <Bslash>t :call VimuxRunCommand("clear; cd " . expand('%:p:h') . "; jest --watch --runInBand" . bufname("%"))<CR>
