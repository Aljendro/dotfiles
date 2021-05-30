" Do not lose focus of quickfix when pressing enter
nnoremap <silent> <buffer> <cr> <CR><C-w>p
" Deleting a line immediately saves the buffer
nnoremap <silent> <buffer> dd dd:w<cr>
" Just jk through the list to see the output
nmap <silent> <buffer> j j<cr>
nmap <silent> <buffer> k k<cr>
