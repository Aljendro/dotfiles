vim.cmd([[

""""""""""""""""""" Conjure

let g:conjure#highlight#enabled = v:true
let g:conjure#highlight#timeout = 250
let conjure#log#wrap = v:true

" Opening the REPL
nmap <leader>cc <localleader>lv
nmap <leader>ct <localleader>lt
" Clear the REPL window
nmap <leader>cr <localleader>lr
" Reset the REPL
nmap <leader>cR <localleader>lR
" Closing the REPL
nmap <leader>cq <localleader>lq

" Working with REPL
nnoremap <leader>ci Go

" Evaluations

"" Evaluate Form Under Cursor
nmap <leader>ee <localleader>ee
"" Evaluate Root Form Under Cursor
nmap <leader>er <localleader>er
"" Evaluate Editor Line
nmap <leader>el <S-v><localleader>E
"" Evaluate Form under cursor and replace with result
nmap <leader>eo <localleader>e!
"" Evaluate Word under cursor
nmap <leader>ew <localleader>ew
"" Evaluate File from disk
nmap <leader>ef <localleader>ef
"" Evaluate File from buffer
nmap <leader>eb <localleader>eb
"" Go to documentation file
nmap <leader>ed <localleader>gd
"" Evaluate form at mark
nmap <expr> <leader>em '<localleader>em' . nr2char(getchar())

"""""""""""""""""" sexp

" Default
let g:sexp_mappings = {}
let g:sexp_enable_insert_mode_mappings = 0

" vim-sexp internal mappings
let g:sexp_mappings = {
  \ 'sexp_outer_list':                'af',
  \ 'sexp_inner_list':                'if',
  \ 'sexp_outer_top_list':            'aF',
  \ 'sexp_inner_top_list':            'iF',
  \ 'sexp_outer_string':              '',
  \ 'sexp_inner_string':              '',
  \ 'sexp_outer_element':             'ae',
  \ 'sexp_inner_element':             'ie',
  \ 'sexp_move_to_prev_bracket':      '(',
  \ 'sexp_move_to_next_bracket':      ')',
  \ 'sexp_move_to_prev_element_head': '<M-b>',
  \ 'sexp_move_to_next_element_head': '<M-w>',
  \ 'sexp_move_to_prev_element_tail': 'g<M-e>',
  \ 'sexp_move_to_next_element_tail': '',
  \ 'sexp_flow_to_prev_close':        '<M-{>',
  \ 'sexp_flow_to_next_open':         '<M-]>',
  \ 'sexp_flow_to_prev_open':         '<M-[>',
  \ 'sexp_flow_to_next_close':        '<M-}>',
  \ 'sexp_flow_to_prev_leaf_head':    '<M-S-b>',
  \ 'sexp_flow_to_next_leaf_head':    '<M-S-w>',
  \ 'sexp_flow_to_prev_leaf_tail':    '<M-S-g>',
  \ 'sexp_flow_to_next_leaf_tail':    '<M-S-e>',
  " \ 'sexp_move_to_prev_top_element':  '',
  " \ 'sexp_move_to_next_top_element':  '',
  \ 'sexp_select_prev_element':       '[e',
  \ 'sexp_select_next_element':       ']e',
  \ 'sexp_indent':                    '==',
  \ 'sexp_indent_top':                '=-',
  \ 'sexp_round_head_wrap_list':      '',
  \ 'sexp_round_tail_wrap_list':      '',
  \ 'sexp_square_head_wrap_list':     '',
  \ 'sexp_square_tail_wrap_list':     '',
  \ 'sexp_curly_head_wrap_list':      '',
  \ 'sexp_curly_tail_wrap_list':      '',
  \ 'sexp_round_head_wrap_element':   '',
  \ 'sexp_round_tail_wrap_element':   '',
  \ 'sexp_square_head_wrap_element':  '',
  \ 'sexp_square_tail_wrap_element':  '',
  \ 'sexp_curly_head_wrap_element':   '',
  \ 'sexp_curly_tail_wrap_element':   '',
  \ 'sexp_insert_at_list_head':       '<leader>si',
  \ 'sexp_insert_at_list_tail':       '<leader>sa',
  \ 'sexp_splice_list':               '<leader>ss',
  \ 'sexp_convolute':                 '<leader>sc',
  \ 'sexp_raise_list':                '<leader>srl',
  \ 'sexp_raise_element':             '<leader>sre',
  " \ 'sexp_swap_list_backward':        '<M-k>', TODO: Conflict, change these out
  " \ 'sexp_swap_list_forward':         '<M-j>',
  " \ 'sexp_swap_element_backward':     '<M-h>',
  " \ 'sexp_swap_element_forward':      '<M-l>',
  \ 'sexp_emit_head_element':         '<M-S-j>',
  \ 'sexp_emit_tail_element':         '<M-S-k>',
  \ 'sexp_capture_prev_element':      '<M-S-h>',
  \ 'sexp_capture_next_element':      '<M-S-l>',
  \ }

]])
