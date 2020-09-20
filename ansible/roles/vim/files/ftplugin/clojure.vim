""""""""""""""""""" Conjure

let g:conjure#mapping#def_word = "d"

" Opening the REPL
nmap <leader>cv <localleader>lv
nmap <leader>cq <localleader>lq

" Evaluations (take cursor back to original postion)
nmap <leader>cc <localleader>ee
nmap <leader>cr <localleader>er
nmap <leader>cl <S-v><localleader>E
nmap <leader>co <localleader>e!
nmap <leader>cw <localleader>ew
nmap <leader>cf <localleader>ef
nmap <leader>cb <localleader>eb
nmap <leader>cd <localleader>d
nmap <expr> <leader>cm '<localleader>em' . nr2char(getchar())

" Working with REPL
nnoremap <leader>ci Go

" Formatting
nmap <leader>pp :call CocActionAsync('format')<cr>

