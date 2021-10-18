" The core settings and keybindings in neovim
"
" Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
"

"""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""" Settings """"""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on
syntax enable
colorscheme dracula

set autowrite
set clipboard=unnamed,unnamedplus                                                      " Yank to the system clipboard and selection clipboard
set completeopt=menu,menuone,noselect
set cursorline                                                                         " Highlights the current line
set display=truncate                                                                   " Show @@@ in the last line if it is truncated.
set expandtab                                                                          " Convert tab to spaces
set fileencoding=utf-8
set foldcolumn=1
set foldtext=FoldText()
set grepformat=%f:%l:%c:%m,%f:%l:%m
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --multiline                     " set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --multiline\ --multiline-dotall
set guitablabel=%t
set hidden                                                                             " Buffer becomes hidden when it is abandoned
set ignorecase                                                                         " Ignore case when searching
set inccommand=nosplit                                                                 " Show preview of changes
set mouse=a                                                                            " Allows mouse click on vim
set nolangremap                                                                        " Do not remap characters
set noshowmode                                                                         " Don't show the -- Insert -- anymore
set noswapfile
set nowrap                                                                             " Do not wrap lines
set nowrapscan                                                                         " Once search hits the bottom, do not go to the top
set nowritebackup                                                                      " Do not make backup when overwriting a file
set nrformats-=octal                                                                   " Do not recognize octal numbers for Ctrl-A and Ctrl-X
set number                                                                             " Turn on line numbers
set relativenumber                                                                     " Relative numbers for quick range commands
set ruler                                                                              " Show the cursor position all the time
set scrolloff=1                                                                        " Keep context around cursor
set shortmess+=c                                                                       " Don't pass messages to |ins-completion-menu|.
set signcolumn=yes                                                                     " Always show the signcolumn, otherwise it would shift the text each time
set smartcase                                                                          " If search contains uppercase characters, disobey ignorecase
set smartindent                                                                        " Indents when creating a newline
set splitbelow                                                                         " Open a window below the current window
set splitright                                                                         " Open a window right of the current window
set t_Co=256
set termguicolors
set updatetime=100                                                                     " Faster CursorHold refresh to highlight matching vars
set virtualedit=block,onemore                                                          " Allow putting cursor on non-characters past the end of the line
set wildmenu                                                                           " Display completion matches in a status line

"""""""""""""""""""""""""""""""""""""""""""""""""
""""""""" Configurations/Keybindings """"""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <Bslash> <Nop>
nnoremap <space> <Nop>
let mapleader = " "
let maplocalleader= "\\"

" Quick edit vimrc (plus cursor disappearing workaround (!ls<cr><cr>))
nnoremap <F1> :tabedit $DOTFILES_DIR/ansible/roles/vim/files/vimrc<cr>:!ls<cr><cr>G

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Abbreviations
"""""""""""""""""""""""""""""""""""""""""""""""""

" Code signature
iabbrev @@ Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
" Do not show visual feedback for grepping in command line
cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() =~# '^grep')  ? 'silent grep \| copen<left><left><left><left><left><left><left><left>'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() =~# '^lgrep') ? 'silent lgrep \| lopen<left><left><left><left><left><left><left><left>' : 'lgrep'
" Always open help in new tab
cnoreabbrev help tab help

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Saves
"""""""""""""""""""""""""""""""""""""""""""""""""

" :W sudo saves the file
" (useful for handling the permission-denied error)
" TODO: Fix for neovim
" command! W execute 'w !sudo tee % > /dev/null' <bar> edit!
" nnoremap <leader>W :W<cr>

" Faster saving
nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>

" Save and resource current file
nnoremap <silent> <leader><leader>w :call SaveAndExec()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Quickfix
"""""""""""""""""""""""""""""""""""""""""""""""""

" Move between quickfix list easily
nnoremap sm :<C-U>cprevious<cr>
nnoremap s, :<C-U>cnext<cr>

" Move between location list easily
nnoremap s. :<C-U>lprevious<cr>
nnoremap s/ :<C-U>lnext<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Splits/Windows
"""""""""""""""""""""""""""""""""""""""""""""""""

" Only split
nnoremap so <C-w>o

" Tab split
nnoremap st <C-w>T

" Vertical split
nnoremap sv <C-w>v

" Close split
nnoremap sc <C-w>c

" Move between windows easily
nnoremap sk <C-w><C-k>
nnoremap sj <C-w><C-j>
nnoremap sl <C-w><C-l>
nnoremap sh <C-w><C-h>

" Scroll window easily
nnoremap <C-j> <C-d>
nnoremap <C-k> <C-u>
nnoremap <M-j> <C-f>
nnoremap <M-k> <C-b>

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

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Search
"""""""""""""""""""""""""""""""""""""""""""""""""

" Easier search and/or replace
nnoremap <leader>rr :<C-U>%s//gcI<Left><Left><Left><Left>
nnoremap <leader>ri :<C-U>%s//gci<Left><Left><Left><Left>
vmap <leader>rw *Ncgn
nmap <leader>rw g*cgn

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call GetSelectedText()<cr>/<C-R>=@/<cr><cr>
vnoremap <silent> # :<C-u>call GetSelectedText()<cr>?<C-R>=@/<cr><cr>

nnoremap * :keepjumps normal! mi*`i<cr>
nnoremap g* :keepjumps normal! mig*`i<cr>
nnoremap # :keepjumps normal! mi#`i<cr>
nnoremap g# :keepjumps normal! mig#`i<cr>

" Count the number of possible replacements (occurrences and lines)
nnoremap <leader>rco :<C-U>%s///gn<cr>

" Center cursor when searching
nnoremap n nzzzv
nnoremap N Nzzzv

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Tabs
"""""""""""""""""""""""""""""""""""""""""""""""""

" Move between tabs easily
noremap su gT
noremap si gt
" Move a window into a new tabpage
noremap <leader>tt <C-w>T
" Move tabs around
nnoremap <leader>th :<C-U>-1tabm<cr>
nnoremap <leader>tl :<C-U>+1tabm<cr>
" Only keep current tab
nnoremap <leader>to :<C-U>tabo<cr>
" Create a new tab at the end
nnoremap <leader>tn :<C-U>tabnew<cr>:tabmove<cr>
" Create a new scratch buffer tab at the end
nnoremap <leader>ts :<C-U>tabnew +setl\ buftype=nofile<cr>:<C-U>tabmove<cr>
" Close the tab
nnoremap <leader>tc :<C-U>tabclose<cr>
" Go to last visited tab
let g:lastTab = 1
nnoremap <leader>tp :<C-U>exec "tabn " . g:lastTab<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Folds
"""""""""""""""""""""""""""""""""""""""""""""""""

" Easier folds
nnoremap <leader>fj zrzz
nnoremap <leader>fk zmzz
nnoremap <leader>fh zMzz
nnoremap <leader>fl zRzz
nnoremap <leader>fo zozz
vnoremap <leader>fo zozz
nnoremap <leader>fO zOzz
vnoremap <leader>fO zOzz
nnoremap <leader>fc zczz
vnoremap <leader>fc zczz
nnoremap <leader>fC zCzz
vnoremap <leader>fC zCzz
nnoremap <leader>fe mazMzv`azczOzz

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Sessions
"""""""""""""""""""""""""""""""""""""""""""""""""

" Quick Session
nnoremap <expr> <leader>ss ':<C-U>wall \| call MakeSession(' . nr2char(getchar()) . ')<cr>'
nnoremap <expr> <leader>sr ':<C-U>wall \| call MakeSession() \| tabonly \| call LoadSession(' . nr2char(getchar()) . ')<cr>'
nnoremap <leader>sd :<C-U>wall \| call LoadSession('default')<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Profiling
"""""""""""""""""""""""""""""""""""""""""""""""""

" Profile everything
nnoremap  <leader>p :<C-U>profile start profile-all.txt \| profile file * \| profile func *<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Macros
"""""""""""""""""""""""""""""""""""""""""""""""""

" Easier macro execution
nnoremap <silent> <leader>m :call RecordMacro()<cr>
nnoremap <expr> <leader>e '@' . nr2char(getchar())
vnoremap <expr> <leader>e ':norm! @' . nr2char(getchar()) . '<cr>'
nnoremap Q @@
vnoremap Q :norm! @@<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Miscellaneous
"""""""""""""""""""""""""""""""""""""""""""""""""

" Undo breakpoints
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

" Keep cursor in same place
nnoremap J mzJ`z

" Normalize Y
nnoremap Y y$

" Close highlighting
nnoremap <leader><enter> :<C-U>noh<cr>

" Better tabbing alignment
vnoremap < <gv
vnoremap > >gv

" Better Vertical block movement
vmap [v [egvv
vmap ]v ]egvv

" Next character remap
nnoremap <leader>; ;

" Use the . to execute once for each line of a visual selection
vnoremap . :normal .<cr>

" Selections
" Whole Buffer
nnoremap <leader>va ggVG

" Faster shifting
nnoremap <Down> 25<C-e>
nnoremap <Up> 25<C-y>
nnoremap <Left> zH
nnoremap <Right> zL

" Open line directly above/below cursor
nnoremap <expr> <leader><M-o> 'k$a<cr><C-o>:norm D' . (virtcol('.') - 1)  . 'i <cr>'
nnoremap <expr> <leader>o '$a<cr><C-o>:norm D' . (virtcol('.') - 1)  . 'i <cr>'

" Fast column formatting
vnoremap <leader>ff :<C-U>'<,'>Tab /

" Insert moving everything to the right down a line
nnoremap <M-i> mii<cr><esc>`ii

" Make Ctrl-c exactly like esc (trigger InsertLeave)
inoremap <C-c> <esc>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Autocommands
"""""""""""""""""""""""""""""""""""""""""""""""""

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
      " Create a default session when vim leaves
      autocmd VimLeave * :call MakeSession()
      " Open quickfix after command that populates it is run
      autocmd QuickFixCmdPost [^l]* cwindow
      autocmd QuickFixCmdPost l* lwindow
      autocmd TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END

