set shiftwidth=2                   " Number of spaces used for autoindent
set tabstop=2                      " Number of spaces that a <Tab> counts for

" Debugger expand for js files
iabbrev d; debugger;
" Run tests with vimux using jest
map <Bslash>t :call VimuxRunCommand("clear; cd " . expand('%:p:h') . "; jest --watch " . bufname("%"))<CR>
" runtime ftplugin/html/sparkup.vim

" Setup formatexpr specified filetype(s).
setl formatexpr=CocAction('formatSelected')

"""""""""""""""""""""" Prettier

nnoremap <leader>pp :Prettier<cr>

