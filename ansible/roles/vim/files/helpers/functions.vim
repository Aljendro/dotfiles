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

" https://vim.fandom.com/wiki/Search_for_visually_selected_text
function! GetSelectedText()
  let l:old_reg = getreg('"')
  let l:old_regtype = getregtype('"')
  norm gvy
  let l:ret = getreg('"')
  call setreg('"', l:old_reg, l:old_regtype)
  exe "norm \<Esc>"
  return l:ret
endfunction

function! MakeSession(...)
  let session_name = a:0 >= 1 ? a:1 : 'default'
  let sessiondir = $HOME . "/.config/nvim/sessions/"
  if (filewritable(sessiondir) != 2)
    exe 'silent !mkdir -p ' b:sessiondir
    redraw!
  endif
  let filename = sessiondir . 'session-' . session_name . '.vim'
  exe "tabdo NERDTreeClose | mksession! " . filename
endfunction

function! LoadSession(...)
  let session_name = a:0 >= 1 ? a:1 : 'default'
  let sessiondir = $HOME . "/.config/nvim/sessions/"
  let filename = sessiondir . 'session-' . session_name . '.vim'
  if (filereadable(filename))
    exe 'source ' filename
  else
    echo "No session loaded."
  endif
endfunction

function! GetFilePathFromGitRoot(filename)
  let git_path = system('git rev-parse --show-toplevel')
  let final_str = substitute(a:filename, git_path, '', '')
  return final_str
endfunction
