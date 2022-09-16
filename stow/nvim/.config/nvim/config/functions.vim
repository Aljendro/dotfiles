" Helper functions
"
" Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
"

" Execute this file
function! SaveAndExec() abort
  if &filetype == 'vim'
    :silent! write
    :source %
  elseif &filetype == 'lua'
    :silent! write
    :lua require("plenary.reload").reload_module'%'
    :luafile %
  endif

  return
endfunction

function! DeleteTrailingSpacesSilent()
  %s/\s\+$//e
  call histdel('search', -1)
endfunction

" https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
function! GetSelectedText()
  let l:saved_reg = @"
  execute "normal! vgvy"

  let @/ = escape(@", "\\/.*'$^~[]")
  let @" = l:saved_reg
endfunction

" https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
function! GetSelectedTextGrep()
  let l:saved_reg = @"
  execute "normal! vgvy"

  let @/ = escape(@", " ")
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
  exe "mksession! " . filename
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
  let l:register = nr2char(getchar())
  " Clear out the register and start recording
  exec "normal! q" . l:register . "q" . "q" . l:register
endfunction

function! AppendNewlineToRegister()
  try
    echo 'Register > '
    let l:register = toupper(nr2char(getchar()))
    exec ':let @' . l:register . '=' . '"\<C-j>"'
    redraw
    echo 'Appended newline to register: ' . l:register
  catch
    redraw
    echohl ErrorMsg
    echo 'Unable to append newline to register'
    echohl NONE
  endtry
endfunction

" Prettier folding
" https://coderwall.com/p/usd_cw/a-pretty-vim-foldtext-function
function! FoldText()
  let l:lpadding = &fdc
  redir => l:signs
  execute 'silent sign place buffer='.bufnr('%')
  redir End
  let l:lpadding += l:signs =~ 'id=' ? 2 : 0

  if (&number)
    let l:lpadding += max([&numberwidth, strlen(line('$'))]) + 1
  elseif (&relativenumber)
    let l:lpadding += max([&numberwidth, strlen(v:foldstart - line('w0')), strlen(line('w$') - v:foldstart), strlen(v:foldstart)]) + 1
  endif

  " expand tabs
  let l:start = substitute(getline(v:foldstart), '\t', repeat(' ', &tabstop), 'g')
  let l:end = substitute(substitute(getline(v:foldend), '\t', repeat(' ', &tabstop), 'g'), '^\s*', '', 'g')

  let l:info = ' (' . (v:foldend - v:foldstart) . ')'
  let l:infolen = strlen(substitute(l:info, '.', 'x', 'g')) + 1
  let l:width = winwidth(0) - l:lpadding - l:infolen

  let l:separator = ' … '
  let l:separatorlen = strlen(substitute(l:separator, '.', 'x', 'g'))
  let l:start = strpart(l:start , 0, l:width - strlen(substitute(l:end, '.', 'x', 'g')) - l:separatorlen)
  let l:text = l:start . ' … ' . l:end

  return l:text . ' ' . repeat('=', l:width - strlen(substitute(l:text, ".", "x", "g")) - 1) . l:info
endfunction

function! EatChar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc

function! CommandAbbreviation(abbreviation, substitution, ...)
  if (getcmdtype() ==# ':')
    " Do not place EatChar here, it will always EatChar in command mode
    " and you need to press <cr> twice when typing
    if (getcmdline() =~# '^' . a:abbreviation)
      :call EatChar('\s')
      return a:substitution
    elseif (getcmdline() =~# "^'<,'>" . a:abbreviation)
      :call EatChar('\s')
      return get(a:, 1, a:substitution)
    endif
  endif
  return a:abbreviation
endfunc

function! Toggle(name, message)
  let b:{a:name} = !get(b:, a:name, 0)
  let trueFalseStr = b:{a:name} ? 'true': 'false'
  echo a:message . trueFalseStr
  return b:{a:name}
endfunction

function! ToggleOff(name, message)
  let b:{a:name} = 0
  echo a:message . 'false'
  return b:{a:name}
endfunction

function! DiffContext(reverse) abort
  call search('^\(@@ .* @@\|[<=>|]\{7}[<=>|]\@!\)', a:reverse ? 'bW' : 'W')
  execute "normal! zz"
endfunction
