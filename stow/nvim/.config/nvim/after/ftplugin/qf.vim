" Do not lose focus of quickfix when pressing enter
nnoremap <silent> <buffer> <cr> <CR><C-w>p
" Deleting a line immediately saves the buffer
nnoremap <silent> <buffer> dd dd:w<cr>