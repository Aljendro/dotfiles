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

" https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
function! GetSelectedText()
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", "\\/.*'$^~[]")
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  let @/ = l:pattern
  let @" = l:saved_reg
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

function! RecordMacro()
  let register = nr2char(getchar())
  " Clear out the register and start recording
  exec "normal! q" . register . "q". "q" . register
endfunction

" Prettier folding
" https://coderwall.com/p/usd_cw/a-pretty-vim-foldtext-function
function! FoldText()
  let l:lpadding = &fdc
  redir => l:signs
  execute 'silent sign place buffer='.bufnr('%')
  redir End
  let l:lpadding += l:signs =~ 'id=' ? 2 : 0

  if exists("+relativenumber")
    if (&number)
      let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
    elseif (&relativenumber)
      let l:lpadding += max([&numberwidth, strlen(v:foldstart - line('w0')), strlen(line('w$') - v:foldstart), strlen(v:foldstart)]) + 1
    endif
  else
    if (&number)
      let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
    endif
  endif

  " expand tabs
  let l:start = substitute(getline(v:foldstart), '\t', repeat(' ', &tabstop), 'g')
  let l:end = substitute(substitute(getline(v:foldend), '\t', repeat(' ', &tabstop), 'g'), '^\s*', '', 'g')

  let l:info = ' (' . (v:foldend - v:foldstart) . ')'
  let l:infolen = strlen(substitute(l:info, '.', 'x', 'g'))
  let l:width = winwidth(0) - l:lpadding - l:infolen

  let l:separator = ' … '
  let l:separatorlen = strlen(substitute(l:separator, '.', 'x', 'g'))
  let l:start = strpart(l:start , 0, l:width - strlen(substitute(l:end, '.', 'x', 'g')) - l:separatorlen)
  let l:text = l:start . ' … ' . l:end

  return l:text . repeat(' ', l:width - strlen(substitute(l:text, ".", "x", "g"))) . l:info
endfunction
