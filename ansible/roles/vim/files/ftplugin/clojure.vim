""""""""""""""""""" Conjure

let g:conjure#mapping#def_word="d"
let conjure#log#wrap = v:true

" Opening the REPL
nmap <leader>cv <localleader>lv
nmap <leader>ct <localleader>lt
nmap <leader>cq <localleader>lq

" Evaluations
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
nmap <leader>ff :call CocActionAsync('format')<cr>

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
  \ 'sexp_move_to_prev_top_element':  '[[',
  \ 'sexp_move_to_next_top_element':  ']]',
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
  \ 'sexp_insert_at_list_head':       '<localleader>i',
  \ 'sexp_insert_at_list_tail':       '<localleader>a',
  \ 'sexp_splice_list':               '<localleader>@',
  \ 'sexp_convolute':                 '<localleader>?',
  \ 'sexp_raise_list':                '<localleader>o',
  \ 'sexp_raise_element':             '<localleader>O',
  \ 'sexp_swap_list_backward':        '<M-k>',
  \ 'sexp_swap_list_forward':         '<M-j>',
  \ 'sexp_swap_element_backward':     '<M-h>',
  \ 'sexp_swap_element_forward':      '<M-l>',
  \ 'sexp_emit_head_element':         '<M-S-j>',
  \ 'sexp_emit_tail_element':         '<M-S-k>',
  \ 'sexp_capture_prev_element':      '<M-S-h>',
  \ 'sexp_capture_next_element':      '<M-S-l>',
  \ }

