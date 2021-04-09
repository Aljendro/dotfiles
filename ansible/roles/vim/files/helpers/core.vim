" The core settings and keybindings in all version of vim
"
" Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
"

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Config
"""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on
syntax enable

set autowrite
set clipboard=unnamed,unnamedplus                     " Yank to the system clipboard and selection clipboard
set cursorline                                        " Highlights the current line
set display=truncate                                  " Show @@@ in the last line if it is truncated.
set expandtab                                         " Convert tab to spaces
set fileencoding=utf-8
set grepformat=%f:%l:%c:%m,%f:%l:%m
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case " Use Rg when using :grep                                                 "
set hidden                                            " Buffer becomes hidden when it is abandoned
set ignorecase                                        " Ignore case when searching
set mouse=a                                           " Allows mouse click on vim
set nobackup                                          " Some servers have issues with backup files (see #649 Coc.nvim)
set nolangremap                                       " Do not remap characters
set noshowmode                                        " Don't show the -- Insert -- anymore
set nowrap                                            " Do not wrap lines
set nowritebackup                                     " Do not make backup when overwriting a file
set nrformats-=octal                                  " Do not recognize octal numbers for Ctrl-A and Ctrl-X
set number                                            " Turn on line numbers
set relativenumber                                    " Relative numbers for quick range commands
set ruler                                             " Show the cursor position all the time
set scrolloff=1                                       " Keep context around cursor
set shortmess+=c                                      " Don't pass messages to |ins-completion-menu|.
set signcolumn=yes                                    " Always show the signcolumn, otherwise it would shift the text each time
set smartcase                                         " If search contains uppercase characters, disobey ignorecase
set smartindent                                       " Indents when creating a newline
set splitbelow                                        " Open a window below the current window
set splitright                                        " Open a window right of the current window
set t_Co=256
set termguicolors                                     " Enables 24-bit RGB color in the TUI
set updatetime=100                                    " Faster CursorHold refresh to highlight matching vars
set virtualedit=block,onemore                         " Allow putting cursor on non-characters past the end of the line
set wildmenu                                          " Display completion matches in a status line

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <Bslash> <Nop>
nnoremap <space> <Nop>
let mapleader = " "
let maplocalleader= "\\"

iabbrev @@ Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
iabbrev """ """"""""""""""""""""

" Quick edit vimrc (plus cursor disappearing workaround (!ls<cr><cr>))
nnoremap <F1> :tabedit $DOTFILES_DIR/ansible/roles/vim/files/vimrc<cr>:!ls<cr><cr>G

" Move between windows easily
nnoremap <C-e> <C-w><C-k>
nnoremap <C-d> <C-w><C-j>
nnoremap <C-f> <C-w><C-l>
nnoremap <C-s> <C-w><C-h>

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

" Vertical split a file path
nnoremap gvf <C-w>vgf
" Reset keybinding for reselecting visual
nnoremap gvv gv

" Close highlighting
nnoremap <leader>th :<C-U>noh<cr>

" Better tabbing alignment
vnoremap < <gv
vnoremap > >gv

" Better Vertical block movement
vmap [v [egvv
vmap ]v ]egvv

" Use the . to execute once for each line of a visual selection
vnoremap . :normal .<cr>

" Quick Session
nnoremap <expr> <localleader>s ':<C-U>wall \| call MakeSession(' . nr2char(getchar()) . ')<cr>'
nnoremap <expr> <localleader>sr ':<C-U>wall \| call MakeSession() \| tabonly \| call LoadSession(' . nr2char(getchar()) . ')<cr>'

" Paste at mark
nnoremap <leader>p :<C-U>call PasteAtMark()<cr>

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

" Easier search and/or replace
nnoremap <leader>rr :<C-U>%s//gcI<Left><Left><Left><Left>
nnoremap <leader>ri :<C-U>%s//gci<Left><Left><Left><Left>
vmap <leader>rw *cgn
nmap <leader>rw g*cgn

" Easier macro execution
nnoremap <silent> <leader>mm :call RecordMacro()<cr>
nnoremap <expr> <leader>me '@' . nr2char(getchar())
nnoremap <leader>mr @@
vnoremap <expr> <leader>me ':norm! @' . nr2char(getchar()) . '<cr>'
vnoremap <leader>mr :norm! @@<cr>

" Selections
" Whole Buffer
nnoremap <leader>va ggVG

" Get all file info as default
nnoremap <C-g> 4<C-g>

" Faster shifting
nnoremap <Down> 5<C-e>
nnoremap <Up> 5<C-y>
nnoremap <Left> zH
nnoremap <Right> zL

" Expand split in new tab
nnoremap <leader>tt :<C-U>tab split<cr>
" Create a new tab at the end
nnoremap <leader>tn :<C-U>tabnew<cr>:<C-U>tabmove<cr>
" Close the tab
nnoremap <leader>tc :<C-U>tabclose<cr>
" Go to last visited tab
let g:lastTab = 1
nnoremap <leader>tl :<C-U>exec "tabn " . g:lastTab<cr>

" Open line directly above/below cursor
nnoremap <expr> <leader>O 'k$a<cr><C-o>:norm D' . (virtcol('.') - 1)  . 'i <cr>'
nnoremap <expr> <leader>o '$a<cr><C-o>:norm D' . (virtcol('.') - 1)  . 'i <cr>'

" Default Prettify Indententation
nnoremap <localleader>f gg=G''

" Make Ctrl-c exactly like esc (trigger InsertLeave)
inoremap <C-c> <esc>

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
      autocmd BufWritePre <buffer> :call DeleteTrailingSpacesSilent()
      " Enter insert mode for terminal upon entering
      autocmd TermOpen * startinsert
      " Easier exiting
      autocmd TermOpen * tnoremap <buffer> <Esc> <C-\><C-n>
augroup END

