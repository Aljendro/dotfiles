" The core keybindings in all version of vim
"
" Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
"

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Config
"""""""""""""""""""""""""""""""""""""""""""""""""

let g:gruvbox_contrast_dark    = 'hard'
let g:gruvbox_hls_cursor       = 'blue'
let g:gruvbox_invert_selection = 0
let g:rainbow_active           = 1

colorscheme gruvbox

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Ctags
"""""""""""""""""""""""""""""""""""""""""""""""""

let g:gutentags_file_list_command = 'rg --files'
let g:gutentags_ctags_exclude = [
      \ 'package-lock.json',
      \ 'package.json',
      \ 'tsconfig.json',
      \]

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Vim Smoothie
"""""""""""""""""""""""""""""""""""""""""""""""""

let g:smoothie_no_default_mappings = v:true

" Move in windows easily
nmap <C-j> <Plug>(SmoothieDownwards)
nmap <C-k> <Plug>(SmoothieUpwards)
nmap <M-j> <Plug>(SmoothieForwards)
nmap <M-k> <Plug>(SmoothieBackwards)

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
"" NERDCommenter
"""""""""""""""""""""""""""""""""""""""""""""""""

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 0

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
"" Snippets
"""""""""""""""""""""""""""""""""""""""""""""""""

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

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
"" Coc (LSP Client)
"""""""""""""""""""""""""""""""""""""""""""""""""

" Make <cr> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<cr>\<c-r>=coc#on_enter()\<cr>"

" Use C to open coc config
call SetupCommandAbbrs('C', 'CocConfig')

inoremap <silent> <expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackSpace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" use <c-space>for trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" Navigate diagnostics
nmap [g <Plug>(coc-diagnostic-prev)
nmap ]g <Plug>(coc-diagnostic-next)
" Naviate Coc List
nmap ]d :<C-U>CocNext<cr>
nmap [d :<C-U>CocPrev<cr>

nmap <leader>ld <Plug>(coc-definition)
nmap <leader>ldv :call CocActionAsync('jumpDefinition', 'vsplit')<cr>
nmap <leader>ldt :call CocActionAsync('jumpDefinition', 'tabe')<cr>
nmap <leader>lt <Plug>(coc-type-definition)
nmap <leader>li <Plug>(coc-implementation)
nmap <leader>lr <Plug>(coc-references)
nmap <leader>lR <Plug>(coc-rename)

" Mappings using CoCList

nnoremap <silent><nowait> <localleader>ll  :<C-U>CocFzfList<cr>
" Show all diagnostics.
nnoremap <silent><nowait> <localleader>ldd  :<C-U>CocFzfList diagnostics<cr>
nnoremap <silent><nowait> <localleader>ldb  :<C-U>CocFzfList diagnostics --current-buf<cr>
" Manage extensions.
nnoremap <silent><nowait> <localleader>le  :<C-U>CocFzfList extensions<cr>
" Resume latest coc list.
nnoremap <silent><nowait> <localleader>lr :<C-U>CocFzfListResume<cr>
" Show commands.
nnoremap <silent><nowait> <localleader>lc  :<C-U>CocFzfList commands<cr>
" Find symbol of current Outline
nnoremap <silent><nowait> <localleader>lo  :<C-U>CocFzfList outline<cr>
" Search workspace symbolS
nnoremap <silent><nowait> <localleader>ls  :<C-U>CocFzfList symbols<cr>

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<cr>

augroup customLSP
  autocmd!
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  " Close the pop up menu after completion
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif
  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')
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
