""""""""""""""""""" Conjure

let g:conjure#mapping#def_word = "d"

" Opening the log buffer
nmap <leader>cv <localleader>lv<cr>
nmap <leader>cq <localleader>lq<cr>

" Evaluations (take cursor back to original postion)
nmap <leader>cc mz<localleader>ee<cr>`z
nmap <leader>cr mz<localleader>er<cr>`z
nmap <leader>co mz<localleader>e!<cr>`z
nmap <leader>cw mz<localleader>ew<cr>`z
nmap <leader>cf mz<localleader>ef<cr>`z
nmap <leader>cb mz<localleader>eb<cr>`z
nmap <leader>cd <localleader>d<cr>

