" Helper functions
"
" Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
"

function! DeleteTrailingSpacesSilent()
  %s/\s\+$//e
  call histdel('search', -1)
endfunction

function! SetupCommandAbbrs(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction

" use <tab> for trigger completion and navigate to the next complete item
function! CheckBackSpace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Paste at mark from the last yank, mark position after yank, move back to
" original position
function! PasteAtMark() abort
  let target_mark = nr2char(getchar())
  exec "normal! mZ'" . target_mark . "P`Z"
endfunction

function! ShowDocumentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
