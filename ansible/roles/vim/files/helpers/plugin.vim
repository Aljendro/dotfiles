" The core keybindings in all version of vim
"
" Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
"

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Config
"""""""""""""""""""""""""""""""""""""""""""""""""

let g:gruvbox_contrast_dark    = 'medium'
let g:gruvbox_hls_cursor       = 'blue'
let g:gruvbox_invert_selection = 0
let g:rainbow_active           = 1

colorscheme gruvbox

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Lightline
"""""""""""""""""""""""""""""""""""""""""""""""""

function! LightlineBranch()
  return winwidth(0) > 70 ? FugitiveHead() : ''
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? &fileencoding : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return winwidth(0) > 70 ? path[len(root)+1:] : fnamemodify(path[len(root)+1:], ':t')
  endif
  return winwidth(0) > 70 ? expand('%') : fnamemodify(expand('%'), ':t')
endfunction

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'fileformat': 'LightlineFileformat',
      \   'filetype': 'LightlineFiletype',
      \   'fileencoding': 'LightlineFileencoding'
      \ },
      \ }

"""""""""""""""""""""""""""""""""""""""""""""""""
"" NERDTree (File Tree Viewer Plugin)
"""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>dd :<C-U>NERDTreeFind<cr>
nnoremap <leader>dt :<C-U>NERDTreeToggle<cr>

let NERDTreeShowLineNumbers  = 0
let NERDTreeMouseMode        = 3
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeShowHidden       = 1
let NERDTreeQuitOnOpen       = 0
let NERDTreeMinimalUI        = 1

let NERDTreeMapOpenVSplit = 'v'
let NERDTreeMapPreviewVSplit = 'gv'

augroup customNERDTree
  autocmd!
  " Close NERDTree if its the last open window
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Git Plugins (Fugitive, Gitgutter, etc.)
"""""""""""""""""""""""""""""""""""""""""""""""""

" Create diffsplit
nnoremap <leader>gds :<C-U>tab split<cr>:<C-U>Gvdiffsplit<cr>
" Open diffs of all the different changed files in tabs
nnoremap <leader>gdd :<C-U>wall \| call MakeSession('diff') \| tabonly \| Git difftool -y \| tabclose 1<cr>
" Restore previous session
nnoremap <leader>gdr :<C-U>wall \| tabonly \| call LoadSession('diff')<cr>
" Refresh difftool
nnoremap <leader>gdu :<C-U>diffupdate<cr>
" Open merge conflicts in different tabs
nnoremap <leader>gdc :<C-U>wall \| call MakeSession('diff') \| tabonly \| Git mergetool -y \| tabclose 1<cr>
" Choose left buffer
nnoremap <expr> <leader>gj ':<C-U>diffget //2/' . GetFilePathFromGitRoot(expand('%')) . '<cr>'
" Choose the right buffer
nnoremap <expr> <leader>gk ':<C-U>diffget //3/' . GetFilePathFromGitRoot(expand('%')) . '<cr>'
" Open git blame with commit and author
nmap <leader>gb :<C-U>Git blame<cr>A
" Open changes in quickfix list
nnoremap <leader>gq :<C-U>GitGutterQuickFix<cr>:copen<cr>
" Undo hunk change
nnoremap <leader>gu :<C-U>GitGutterUndoHunk<cr>
" FZF-checkout plugin
nnoremap <leader>gg  :<C-U>FGBranches<cr>
nnoremap <leader>gt  :<C-U>FGTags<cr>

cabbrev gf Git fetch origin
cabbrev gb Git branch
cabbrev gbd Git branch -d
cabbrev gbdr Git push origin --delete
cabbrev gpl Git pull
cabbrev ggpull Git pull origin <C-R>=FugitiveHead()<cr>
cabbrev gp Git push
cabbrev ggpush Git push origin <C-R>=FugitiveHead()<cr>
cabbrev gco Git checkout
cabbrev gcb Git checkout -b
cabbrev gcd Git checkout develop
cabbrev gcm Git checkout master
cabbrev gac Git commit -a -m
cabbrev gsta Git stash push -u
cabbrev gstd Git stash drop
cabbrev gstl Git stash list
cabbrev gstp Git stash pop

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Ripgrep
"""""""""""""""""""""""""""""""""""""""""""""""""

" Search for word under cursor in project
nnoremap <leader>/w :<C-U>silent grep! <C-R>=expand("<cword>")<cr><cr>:copen<cr>
" Search for highlighted word in project
vnoremap <leader>/w :<C-U>call GetSelectedText()<cr>:silent grep! -F -- <C-R>=@/<cr><cr>:copen<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" FZF
"""""""""""""""""""""""""""""""""""""""""""""""""

let g:fzf_command_prefix = 'F'
let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.98 } }
let g:fzf_preview_window = ['right:60%', 'ctrl-/']

" Do not search the file path with rip grep
" (using with_preview 'options' parameter)
command! -bang -nargs=* FARg
      \ call fzf#vim#grep(
      \   'rg --multiline --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
      \   fzf#vim#with_preview({'options': '--delimiter=: --nth=4..'}, 'right'), <bang>0)

nnoremap <leader>sf  :<C-U>FFiles<cr>
nnoremap <leader>sw  :<C-U>FWindows<cr>
nnoremap <leader>sg  :<C-U>FGFiles?<cr>
nnoremap <leader>sh  :<C-U>FCommits<cr>
nnoremap <leader>sc  :<C-U>FBCommits<cr>
nnoremap <leader>sa  :<C-U>FRg<cr>
nnoremap <leader>sA  :<C-U>FARg<cr>
nnoremap <leader>s/  :<C-U>FHistory/<cr>
vnoremap <leader>s/  :<C-U>FHistory/<cr>
nnoremap <leader>s:  :<C-U>FHistory:<cr>
vnoremap <leader>s:  :<C-U>FHistory:<cr>
nnoremap <leader>ss  :<C-U>FBLines<cr>
nnoremap <leader>sl  :<C-U>FLines<cr>
nnoremap <leader>sm  :<C-U>FMarks<cr>
nnoremap <leader>stt :<C-U>FTags<cr>
nnoremap <leader>stb :<C-U>FBTags<cr>
nnoremap <leader>so  :<C-U>FBuffers<cr>
nnoremap <leader>su  :<C-U>FSnippets<cr>
nnoremap <leader>sk  :<C-U>FMaps<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" LSP Client
"""""""""""""""""""""""""""""""""""""""""""""""""

augroup customLSP
  autocmd!
  " Update signature help on jump placeholder.
  " autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  " Close the pop up menu after completion
  " autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif
  " Highlight the symbol and its references when holding the cursor.
  " autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Sneak
"""""""""""""""""""""""""""""""""""""""""""""""""

let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
let g:sneak#target_labels = "fjdkslarueiwovmctyghbnqpzFJDKSLARUEIWOVMCTYGHBNQPZ"

" 2-character Sneak (default)
nmap <leader>j <Plug>Sneak_s
nmap <leader>k <Plug>Sneak_S
" visual-mode
xmap <leader>j <Plug>Sneak_s
xmap <leader>k <Plug>Sneak_S
" operator-pending-mode
omap <leader>j <Plug>Sneak_s
omap <leader>k <Plug>Sneak_S

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Vimux
"""""""""""""""""""""""""""""""""""""""""""""""""

" Prompt for a command to run
map <Leader>vp :<C-U>VimuxPromptCommand<cr>
" Run last command executed by VimuxRunCommand
map <Leader>vl :<C-U>VimuxRunLastCommand<cr>
" Inspect runner pane
map <Leader>vi :<C-U>VimuxInspectRunner<cr>
" Close vim tmux runner opened by VimuxRunCommand
map <Leader>vq :<C-U>VimuxCloseRunner<cr>
" Interrupt any command running in the runner pane
map <Leader>vx :<C-U>VimuxInterruptRunner<cr>
" Zoom the runner pane (use <bind-key> z to restore runner pane)
map <Leader>vz :<C-U>call VimuxZoomRunner()<cr>
" Clear the tmux history of the runner pane
map <Leader>vc :<C-U>call VimuxRunCommand("clear;")<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Closetag
"""""""""""""""""""""""""""""""""""""""""""""""""

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.

let g:closetag_filetypes = "html,javascriptreact,typescriptreact"

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Delimitmate
"""""""""""""""""""""""""""""""""""""""""""""""""

let delimitMate_excluded_ft = "clojure"
