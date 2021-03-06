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
vmap <M-j> <Plug>(SmoothieForwards)
vmap <M-k> <Plug>(SmoothieBackwards)

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

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \ },
      \ 'component_function': {
      \   'gitbranch': 'LightlineBranch',
      \   'fileformat': 'LightlineFileformat',
      \   'filetype': 'LightlineFiletype',
      \   'fileencoding': 'LightlineFileencoding'
      \ },
      \ }

"""""""""""""""""""""""""""""""""""""""""""""""""
"" NERDTree (File Tree Viewer Plugin)
"""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>n     :<C-U>NERDTreeToggle<cr>
nnoremap <leader><C-n> :<C-U>NERDTreeFind<cr>

let NERDTreeShowLineNumbers  = 1
let NERDTreeMouseMode        = 3
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeShowHidden       = 1
let NERDTreeQuitOnOpen       = 0
let NERDTreeMinimalUI        = 1
let g:webdevicons_conceal_nerdtree_brackets = 0
let g:NERDTreeDirArrowExpandable = ""
let g:NERDTreeDirArrowCollapsible = ""

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
nnoremap <leader>ds :<C-U>tab split<cr>:<C-U>Gvdiffsplit<cr>
" Open diffs of all the different changed files in tabs
nnoremap <leader>dd :<C-U>wall \| call MakeSession('diff') \| tabonly \| Git difftool -y \| tabclose 1<cr>
" Restore previous session
nnoremap <leader>dr :<C-U>wall \| tabonly \| call LoadSession('diff')<cr>
" Refresh difftool
nnoremap <leader>du :<C-U>diffupdate<cr>
" Open merge conflicts in different tabs
nnoremap <leader>dc :<C-U>wall \| call MakeSession('diff') \| tabonly \| Git mergetool -y \| tabclose 1<cr>
" Choose left buffer
nnoremap <expr> <leader>dj ':<C-U>diffget //2/' . GetFilePathFromGitRoot(expand('%')) . '<cr>'
" Choose the right buffer
nnoremap <expr> <leader>dk ':<C-U>diffget //3/' . GetFilePathFromGitRoot(expand('%')) . '<cr>'
" Open git blame with commit and author
nmap <leader>gb :<C-U>Git blame<cr>A

cabbrev gb Git branch
cabbrev gbd Git branch -d
cabbrev gbdr Git push origin --delete
cabbrev gp Git push
cabbrev gco Git checkout
cabbrev gcb Git checkout -b
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

let g:rg_command = 'rg --vimgrep -S'
let g:rg_highlight = v:true

" Search for word under cursor in project
nnoremap <leader>fw :Rg <C-R>=expand("<cword>")<cr><cr>
" Search for highlighted word in project
vnoremap <leader>fw y:<C-U>Rg <C-R>=escape(@",'/\')<cr><cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" FZF
"""""""""""""""""""""""""""""""""""""""""""""""""

let g:fzf_command_prefix = 'F'

" Do not search the file path with rip grep
" (using with_preview 'options' parameter)
command! -bang -nargs=* FARg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
      \   fzf#vim#with_preview({'options': '--delimiter=: --nth=4..'}, 'right'), <bang>0)

nnoremap <leader>ff  :<C-U>FFiles<cr>
nnoremap <leader>fg  :<C-U>FGFiles?<cr>
nnoremap <leader>fc  :<C-U>FCommits<cr>
nnoremap <leader>fr  :<C-U>FRg<cr>
nnoremap <leader>fa  :<C-U>FARg<cr>
nnoremap <leader>fh  :<C-U>FHistory:<cr>
vnoremap <leader>fh  :<C-U>FHistory:<cr>
nnoremap <leader>fb  :<C-U>FBLines<cr>
nnoremap <leader>fl  :<C-U>FLines<cr>
nnoremap <leader>fs  :<C-U>FHistory/<cr>
vnoremap <leader>fs  :<C-U>FHistory/<cr>
nnoremap <leader>fm  :<C-U>FMarks<cr>
nnoremap <leader>ft  :<C-U>FTags<cr>
nnoremap <leader>fj  :<C-U>FBTags<cr>

nnoremap <leader>fo  :<C-U>FBuffers<cr>

augroup customFZF
  autocmd!
  autocmd FileType fzf tunmap <buffer> <Esc>
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Coc (LSP Client)
"""""""""""""""""""""""""""""""""""""""""""""""""

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use C to open coc config
call SetupCommandAbbrs('C', 'CocConfig')

inoremap <silent><expr> <Tab>
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

nmap <leader>ad <Plug>(coc-definition)
nmap <leader>at <Plug>(coc-type-definition)
nmap <leader>ai <Plug>(coc-implementation)
nmap <leader>ar <Plug>(coc-references)
nmap <leader>aR <Plug>(coc-rename)

" Mappings using CoCList

" Show all diagnostics.
nnoremap <silent><nowait> <leader>ld  :<C-U>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <leader>le  :<C-U>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <leader>lc  :<C-U>CocList commands<cr>
" Find symbol of current Outline
nnoremap <silent><nowait> <leader>lo  :<C-U>CocList outline<cr>
" Search workspace symbolS
nnoremap <silent><nowait> <leader>ls  :<C-U>CocList -I symbols<cr>
" Resume latest coc list.
nnoremap <silent><nowait> <leader>lr :<C-U>CocListResume<cr>

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

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
"" Easy Motion
"""""""""""""""""""""""""""""""""""""""""""""""""

let g:EasyMotion_do_mapping       = 0
let g:EasyMotion_smartcase        = 1
let g:EasyMotion_use_smartsign_us = 1

map <leader>j <Plug>(easymotion-bd-f)
map <leader><C-j> <Plug>(easymotion-bd-jk)
map <leader>k <Plug>(easymotion-bd-w)
map <leader><C-k> <Plug>(easymotion-bd-e)

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Vimux
"""""""""""""""""""""""""""""""""""""""""""""""""

" Prompt for a command to run
map <Leader>vp :<C-U>VimuxPromptCommand<CR>
" Run last command executed by VimuxRunCommand
map <Leader>vl :<C-U>VimuxRunLastCommand<CR>
" Inspect runner pane
map <Leader>vi :<C-U>VimuxInspectRunner<CR>
" Close vim tmux runner opened by VimuxRunCommand
map <Leader>vq :<C-U>VimuxCloseRunner<CR>
" Interrupt any command running in the runner pane
map <Leader>vx :<C-U>VimuxInterruptRunner<CR>
" Zoom the runner pane (use <bind-key> z to restore runner pane)
map <Leader>vz :<C-U>call VimuxZoomRunner()<CR>
" Clear the tmux history of the runner pane
map <Leader>vc :<C-U>call VimuxRunCommand("clear;")<CR>

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
