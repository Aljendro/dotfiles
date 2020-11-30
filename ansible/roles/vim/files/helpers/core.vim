" The core settings and keybindings in all version of vim
"
" Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
"

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Config
"""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on
syntax enable

set autoindent                     " Copy indentation from current line when opening new line
set autowrite
set background=dark                " Indicated the type of background
set clipboard=unnamedplus          " Yank to the system clipboard
set cmdheight=2                    " Give more space for displaying messages.
set cursorline                     " Highlights the current line
set display=truncate               " Show @@@ in the last line if it is truncated.
set encoding=utf-8
set expandtab                      " Convert tab to spaces
set fileencoding=utf-8
set guifont=Ubuntu\ Mono\ Bold\ 14
set hidden                         " Buffer becomes hidden when it is abandoned
set hlsearch                       " Highlight searches
set ignorecase                     " Ignore case when searching
set incsearch                      " Do incremental searching when it's possible to timeout.
set laststatus=2                   " Always have a status line
set mouse=a                        " Allows mouse click on vim
set nobackup                       " Some servers have issues with backup files (see #649 Coc.nvim)
set nolangremap                    " Do not remap characters
set noshowmode                     " Don't show the -- Insert -- anymore
set nowrap                         " Do not wrap lines
set nowritebackup                  " Do not make backup when overwriting a file
set nrformats-=octal               " Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
set ruler                          " Show the cursor position all the time
set scrolloff=1                    " Keep context around cursor
set shiftwidth=2
set shortmess+=c                   " Don't pass messages to |ins-completion-menu|.
set showcmd                        " Display incomplete commands
set signcolumn=yes                 " Always show the signcolumn, otherwise it would shift the text each time
set smartcase                      " If search contains uppercase characters, disobey ignorecase
set smartindent                    " Indents when creating a newline
set smarttab                       " Discerns between 2 vs. 4 when tabbing
set splitbelow                     " Open a window below the current window
set splitright                     " Open a window right of the current window
set t_Co=256
set tabstop=2
set termguicolors
set timeout                        " Time out for mappings
set timeoutlen=1000
set ttimeout                       " Time out for key codes
set ttimeoutlen=100
set updatetime=100                 " Set the amount of time vim waits to write to the swap file
set wildmenu                       " Display completion matches in a status line

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <space> <Nop>
let mapleader = " "
let maplocalleader= ","

iabbrev @@ Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
iabbrev """ """"""""""""""""""""

" Quick edit vimrc (plus cursor disappearing workaround (!ls<cr><cr>))
nnoremap <F1> :tabedit $DOTFILES_DIR/ansible/roles/vim/files/vimrc<cr>:!ls<cr><cr>G

" Move between windows easily
nnoremap <C-e> <C-w><C-k>
nnoremap <C-d> <C-w><C-j>
nnoremap <C-f> <C-w><C-l>
nnoremap <C-s> <C-w><C-h>

" Move in windows easily
nnoremap <C-j> <C-d>
nnoremap <C-k> <C-u>
nnoremap <M-j> <C-f>
nnoremap <M-k> <C-b>

" Move between tabs easily
noremap <C-h> :<C-U>tabprevious<cr>
noremap <C-l> :<C-U>tabnext<cr>

" Move between quickfix items easily
nnoremap <M-h> :<C-U>cprevious<cr>
nnoremap <M-l> :<C-U>cnext<cr>

" Move windows easily
nnoremap <C-w>j <C-w>J
nnoremap <C-w>k <C-w>K
nnoremap <C-w>l <C-w>L
noremap <C-w>h <C-w>H

" Resize windows
nnoremap <M-d> :<C-U>resize -4<cr>
nnoremap <M-e> :<C-U>resize +4<cr>
nnoremap <M-s> :<C-U>vertical resize +16<cr>
nnoremap <M-f> :<C-U>vertical resize -16<cr>

" Close highlighting
nnoremap <Bslash>h :<C-U>noh<cr>

" Better tabbing alignment
vnoremap < <gv
vnoremap > >gv

" Better Vertical block movement
vmap [v [egv
vmap ]v ]egv

" Paste at mark
nnoremap <Bslash>p :<C-U>call PasteAtMark()<cr>
" Open mark in vertical split
nnoremap <expr> <Bslash>o '<C-w>v`' . nr2char(getchar())

" Search for visually selected word in buffer
vnoremap <silent> * :call setreg("/",
    \ substitute(GetSelectedText(),
    \ '\_s\+',
    \ '\\_s\\+', 'g')
    \ )<cr>:set hls<cr>

nnoremap * :keepjumps normal! mi*`i<cr>
nnoremap g* :keepjumps normal! mig*`i<cr>

" Count the number of possible replacements (occurrences and lines)
nnoremap <leader>rco :<C-U>%s///gn<cr>
nnoremap <leader>rcl :<C-U>%s///n<cr>

" Easier search and/or replace (TODO: figure how to position cursor properly)
nnoremap <leader>rr :<C-U>%s//gcI<Left><Left><Left><Left>
nnoremap <leader>ri :<C-U>%s//gci<Left><Left><Left><Left>
vmap <leader>rw *cgn
nmap <leader>rw g*cgn

" Selections
" Whole Buffer
nnoremap <leader>sa ggVG

" Faster shifting
nnoremap <Down> 5<C-e>
nnoremap <Up> 5<C-y>
nnoremap <Left> zH
nnoremap <Right> zL

nnoremap <leader>ts :<C-U>windo w<cr>:tabclose<cr>

" Expand split in new tab
nnoremap <leader>tt :<C-U>tab split<cr>
" Create a new tab at the end
nnoremap <leader>tn :<C-U>tabnew<cr>:<C-U>tabmove<cr>
" Close the tab
nnoremap <leader>tc :<C-U>tabclose<cr>
" Go to last visited tab
let g:lastTab = 1
nnoremap <leader>tl :<C-U>exec "tabn " . g:lastTab<cr>

" Quick open the quickfix list
nnoremap <leader>oq :<C-U>botright copen<cr>

" Default Prettify Indententation
nnoremap <leader>pp gg=G''

augroup customVim
  autocmd!
  " When editing a file, always jump to the last known cursor position.
  autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif
  " Removing the o option removes adding a comment when open new line
  autocmd Filetype * set formatoptions-=o
  " Set the last known tab when switching tabs
  autocmd TabLeave * let g:lastTab = tabpagenr()
  " Source vimrc when saving the file
  autocmd BufWritePost $DOTFILES_DIR/ansible/roles/vim/files/vimrc,$DOTFILES_DIR/ansible/roles/vim/files/*.vim nested source $MYVIMRC
  " Delete trailing spaces
  autocmd FileType c,cpp,java,javascript,vim,python,yaml,sh,tmux autocmd BufWritePre <buffer> :call DeleteTrailingSpacesSilent()
  " Add line numbers
  autocmd BufEnter * set number
  " Toggle relative line number mode when inserting
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
  " Enter insert mode for terminal upon entering
  autocmd TermOpen * startinsert
  " Easier exiting
  autocmd TermOpen * tnoremap <buffer> <Esc> <C-\><C-n>
augroup END

"""""""""""""""""""""" Javascript Family

augroup customJavascriptFamily
  autocmd!
  autocmd FileType javascript,javascriptreact,typescript,typescriptreact setl tabstop=2 | setl shiftwidth=2
  " User prettier
  autocmd FileType graphql,html,json,javascript,javascriptreact,typescript,typescriptreact nnoremap <buffer> <leader>pp :Prettier<cr>
  " Debugger expand for js files
  autocmd FileType javascript,javascriptreact,typescript,typescriptreact iabbrev <buffer> d; debugger;
  " Run tests with vimux using jest
  autocmd FileType javascript,javascriptreact,typescript,typescriptreact map <buffer> <Bslash>t :call VimuxRunCommand("clear; cd " . expand('%:p:h') . "; jest --watch " . bufname("%"))<CR>
augroup END



