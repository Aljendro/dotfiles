" The core settings and keybindings in neovim
"
" Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
"

"""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""" Settings """"""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on
colorscheme tokyonight

let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_python_provider = 0
let g:node_host_prog = expand("~/.nvm/versions/node/v14.17.1/bin/neovim-node-host")
let g:python3_host_prog = expand("/usr/bin/python3")

set autowrite
set clipboard=unnamed,unnamedplus
set completeopt=menu,menuone,noselect
set cursorline
set dictionary+=/usr/share/dict/words
set display=truncate
set expandtab
set fillchars+=diff:\ ,fold:.
set foldcolumn=1
set foldtext=FoldText()
set grepformat=%f:%l:%c:%m,%f:%l:%m
set grepprg=rg\ --vimgrep\ --no-heading
set guitablabel=%t
set hidden
set ignorecase
set inccommand=nosplit
set iskeyword+=-
set mouse=a
set noshowmode
set noswapfile
set nowrap
set nowrapscan
set nowritebackup
set nrformats-=octal
set number
set relativenumber
set scrolloff=1
set shortmess+=c
set signcolumn=yes
set smartcase
set smartindent
set splitbelow
set splitright
set updatetime=100
set virtualedit=block,onemore

"""""""""""""""""""""""""""""""""""""""""""""""""
""""""""" Configurations/Keybindings """"""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <Bslash> <Nop>
nnoremap <space> <Nop>
let mapleader = " "
let maplocalleader= "\\"

" Quick edit vimrc (plus cursor disappearing workaround (!ls<cr><cr>))
nnoremap <F1> :tabedit $DOTFILES_DIR/stow/nvim/.config/nvim/config/core.vim<cr>
" Quick save
nnoremap <silent> <leader>r :lua require('plenary.reload').reload_module('aljendro', true)<cr>:source $MYVIMRC<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Abbreviations
"""""""""""""""""""""""""""""""""""""""""""""""""

" Code signature
iabbrev @@ Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
" Do not show visual feedback for grepping in command line
cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() =~# '^grep')  ? 'silent grep \| copen<left><left><left><left><left><left><left><left>'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() =~# '^lgrep') ? 'silent lgrep \| lopen<left><left><left><left><left><left><left><left>' : 'lgrep'
" Always open help in new tab
cnoreabbrev tah tab help

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Saves
"""""""""""""""""""""""""""""""""""""""""""""""""

" Faster saving
nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Quickfix
"""""""""""""""""""""""""""""""""""""""""""""""""

" Move between quickfix list easily
nnoremap sn :cNfile<cr>zz
nnoremap sm :cprevious<cr>zz
nnoremap s, :cnext<cr>zz
nnoremap s. :cnfile<cr>zz

" Move between location list easily
nnoremap so :lprevious<cr>zz
nnoremap sp :lnext<cr>zz

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Splits/Windows
"""""""""""""""""""""""""""""""""""""""""""""""""

" Only split
nnoremap ss <C-w>o

" Tab split
nnoremap st :tab split<cr>

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
xnoremap <C-j> <C-d>
nnoremap <C-k> <C-u>
xnoremap <C-k> <C-u>
nnoremap <M-j> <C-f>
xnoremap <M-j> <C-f>
nnoremap <M-k> <C-b>
xnoremap <M-k> <C-b>

" Move windows easily
nnoremap <C-w>j <C-w>J
nnoremap <C-w>k <C-w>K
nnoremap <C-w>l <C-w>L
nnoremap <C-w>h <C-w>H

" Resize windows
nnoremap <M-d> :resize -4<cr>
nnoremap <M-e> :resize +4<cr>
nnoremap <M-s> :vertical resize +16<cr>
nnoremap <M-f> :vertical resize -16<cr>

" Vertical split a file path
nnoremap sfv <C-w>vgf

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Search
"""""""""""""""""""""""""""""""""""""""""""""""""

" Easier search and/or replace
nnoremap <leader>/r :%s//gci<Left><Left><Left><Left>
" Count the number of possible replacements (occurrences and lines)
nnoremap <leader>/c :%s///gn<cr>

" Change word under cursor giving the ability to reapply with .
vmap <leader>/w *Ncgn
nmap <leader>/w g*cgn

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call GetSelectedText()<cr>/<C-R>=@/<cr><cr>
vnoremap <silent> # :call GetSelectedText()<cr>?<C-R>=@/<cr><cr>

" Maintain position when you hit * or #
nnoremap * :keepjumps normal! mi*`i<cr>
nnoremap g* :keepjumps normal! mig*`i<cr>
nnoremap # :keepjumps normal! mi#`i<cr>
nnoremap g# :keepjumps normal! mig#`i<cr>

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
noremap <leader>tw <C-w>T
" Move tabs around
nnoremap <leader>tj :-1tabm<cr>
nnoremap <leader>tk :+1tabm<cr>
" Only keep current tab
nnoremap <leader>to :tabo<cr>
" Create a new tab at the end
nnoremap <leader>tn :tabnew<cr>:tabmove<cr>
" Create a new scratch buffer tab at the end
nnoremap <leader>ts :tabnew +setl\ buftype=nofile<cr>:tabmove<cr>
" Close the tab
nnoremap <leader>tc :tabclose<cr>
" Go to last visited tab
let g:lastTab = 1
nnoremap <leader>tp :exec "tabn " . g:lastTab<cr>

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
nnoremap <expr> <leader>ss ':wall \| call MakeSession(' . nr2char(getchar()) . ')<cr>'
nnoremap <expr> <leader>sr ':wall \| call MakeSession() \| tabonly \| call LoadSession(' . nr2char(getchar()) . ')<cr>'
nnoremap <leader>sd :wall \| call LoadSession('default')<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Profiling
"""""""""""""""""""""""""""""""""""""""""""""""""

" Profile everything
nnoremap <leader>p :profile start profile-all.txt \| profile file * \| profile func *<cr>

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

" Close highlighting
nnoremap <leader><enter> :noh<cr>

" Better tabbing alignment
vnoremap < <gv
vnoremap > >gv

" Next character remap
nnoremap <leader>; ;

" Use the . to execute once for each line of a visual selection
vnoremap . :normal .<cr>

" Faster shifting
nnoremap <Down> 5<C-e>
nnoremap <Up> 5<C-y>
nnoremap <Left> zH
nnoremap <Right> zL

" Open line directly above/below cursor
nnoremap <expr> <leader><M-o> 'k$a<cr><C-o>:norm D' . (virtcol('.') - 1)  . 'i <cr>'
nnoremap <expr> <leader>o '$a<cr><C-o>:norm D' . (virtcol('.') - 1)  . 'i <cr>'

" Fast column formatting
vnoremap <leader>ff :'<,'>Tab /

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
      " Delete trailing spaces
      autocmd BufWritePre <buffer> :call DeleteTrailingSpacesSilent()
      " Create a default session when vim leaves
      autocmd VimLeave * :call MakeSession()
      " Open quickfix after command that populates it is run
      autocmd QuickFixCmdPost [^l]* cwindow
      autocmd QuickFixCmdPost l* lwindow
      " Highlight the movement selection
      autocmd TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=150 }
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Surround
"""""""""""""""""""""""""""""""""""""""""""""""""

nmap <leader>' ysiw'
nmap <leader>" ysiw"
nmap <leader>` ysiw`
nmap <leader>( ysiw)
nmap <leader>{ ysiw}

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Ultisnips
"""""""""""""""""""""""""""""""""""""""""""""""""

let g:UltiSnipsRemoveSelectModeMappings = 0

let snippetPath=$HOME.'/.config/nvim/ultisnips'
let g:UltiSnipsSnippetDirectories=[snippetPath]

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Git Plugins (Fugitive, Gitgutter, etc.)
"""""""""""""""""""""""""""""""""""""""""""""""""

" Remap the fugitive s(tage) command to S
let g:nremap = {'s': 'S'}
let g:xremap = {'s': 'S'}
" Open up Fugitive in a tab
nnoremap <leader>gg :tab G<cr>
" Create diffsplit
nnoremap <leader>gd :tab split<cr>:Gvdiffsplit<cr>
" Load changes into quickfix list
nnoremap <leader>gc :Git difftool<cr>:cclose<cr>
" Open merge conflicts in different tabs
nnoremap <leader>gC :Git mergetool<cr>:cclose<cr>
" Open git blame with commit and author
nmap <leader>gb :Git blame<cr>A
" Refresh difftool
nnoremap <leader>gu :diffupdate<cr>
" Choose left buffer
nnoremap <expr> <leader>gj ':diffget //2/' . GetFilePathFromGitRoot(expand('%')) . '<cr>'
" Choose the right buffer
nnoremap <expr> <leader>gk ':diffget //3/' . GetFilePathFromGitRoot(expand('%')) . '<cr>'

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
cabbrev gsta Git stash push -u -m
cabbrev gstd Git stash drop
cabbrev gstl Git stash list
cabbrev gstp Git stash pop

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Fuzzy Finder (Telescope)
"""""""""""""""""""""""""""""""""""""""""""""""""

let g:fzf_command_prefix = 'F'
let g:fzf_layout = { 'window': { 'width': 0.99, 'height': 0.99 } }
let g:fzf_preview_window = ['up:40%:hidden', 'ctrl-/']

" Do not search the file path with rip grep
" (using with_preview 'options' parameter)
command! -bang -nargs=* FARg
      \ call fzf#vim#grep(
      \   'rg --multiline --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
      \   fzf#vim#with_preview({'options': '--delimiter=: --nth=4..'}, 'up:40%:hidden', 'ctrl-/'), <bang>0)

nnoremap ;/    :lua require('telescope.builtin').search_history()<cr>
nnoremap ;;    :lua require('telescope.builtin').command_history()<cr>
vnoremap ;;    :lua require('telescope.builtin').command_history()<cr>
nnoremap ;a    :FRg<cr>
nnoremap ;A    :FARg<cr>
nnoremap ;b    :lua require('telescope.builtin').buffers({sort_mru=true})<cr>
nnoremap ;c    :lua require('telescope.builtin').commands()<cr>
nnoremap ;f    :lua require('telescope.builtin').find_files({hidden=true})<cr>
nnoremap ;gc   :lua require('telescope.builtin').git_bcommits()<cr>
nnoremap ;gC   :lua require('telescope.builtin').git_commits()<cr>
nnoremap ;gb   :lua require('telescope.builtin').git_branches()<cr>
nnoremap ;gf   :lua require('telescope.builtin').git_files()<cr>
nnoremap ;gg   :lua require('telescope.builtin').live_grep()<cr>
nnoremap ;gs   :lua require('telescope.builtin').grep_string({use_regex=true, search=''})<left><left><left>
nnoremap ;gS   :lua require('telescope.builtin').git_stash()<cr>
nnoremap ;h    :lua require('telescope.builtin').help_tags()<cr>
nnoremap ;j    :lua require('telescope.builtin').jumplist({ignore_filename=false})<cr>
nnoremap ;k    :lua require('telescope.builtin').keymaps()<cr>
nnoremap ;la   :lua require('telescope.builtin').lsp_code_actions()<cr>
" TODO: Figure out why this is not working with visual selection
" vnoremap ;la   :lua require('telescope.builtin').lsp_range_code_actions()<cr>
nnoremap ;ld   :lua require('telescope.builtin').diagnostics({bufnr=0})<cr>
nnoremap ;lm   :lua require('telescope.builtin').man_pages()<cr>
nnoremap ;ls   :lua require('telescope.builtin').lsp_document_symbols()<cr>
nnoremap ;lD   :lua require('telescope.builtin').diagnostics()<cr>
nnoremap ;lS   :lua require('telescope.builtin').lsp_workspace_symbols({query=''})<left><left><left>
nnoremap ;m    :lua require('telescope.builtin').marks()<cr>
nnoremap ;n    :lua require('telescope').extensions.neoclip.default()<cr>
nnoremap ;of   :lua require('telescope.builtin').oldfiles()<cr>
nnoremap ;r    :lua require('telescope.builtin').resume()<cr>
nnoremap ;R    :lua require('telescope.builtin').registers()<cr>
nnoremap ;s    :lua require('telescope.builtin').current_buffer_fuzzy_find({skip_empty_lines=true})<cr>
nnoremap ;t    :lua require('telescope.builtin').treesitter()<cr>
nnoremap ;vf   :lua require('telescope.builtin').filetypes()<cr>
nnoremap ;vo   :lua require('telescope.builtin').vim_options()<cr>
nnoremap ;w    :Telescope grep_string<cr>
vnoremap ;w    :call GetSelectedText()<cr>:Telescope grep_string use_regex=true search=<C-R>=@/<cr><cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" LSP Client
"""""""""""""""""""""""""""""""""""""""""""""""""

highlight LspReference guifg=NONE guibg=#665c54 guisp=NONE gui=NONE cterm=NONE ctermfg=NONE ctermbg=59
highlight! link LspReferenceText LspReference
highlight! link LspReferenceRead LspReference
highlight! link LspReferenceWrite LspReference

augroup customLSP
  autocmd!
  " autocmd CursorHold  * lua vim.lsp.buf.document_highlight()
  " autocmd CursorHoldI * lua vim.lsp.buf.document_highlight()
  " autocmd CursorMoved * lua vim.lsp.buf.clear_references()
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""
"" DAP Client
"""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>dd  :lua require('dap').toggle_breakpoint()<cr>
nnoremap <leader>dD  :lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>
nnoremap <leader>dj  :lua require('dap').step_into()<cr>
nnoremap <leader>dk  :lua require('dap').step_out()<cr>
nnoremap <leader>dl  :lua require('dap').step_over()<cr>
nnoremap <leader>dC  :lua require('dap').run_to_cursor()<cr>
nnoremap <leader>d;  :lua require('dap').down()<cr>
nnoremap <leader>dh  :lua require('dap').up()<cr>
nnoremap <leader>dc  :lua require('dap').continue()<cr>
nnoremap <leader>ds  :lua require('dap').close()<cr>
nnoremap <leader>dl  :lua require('dap').run_last()<cr>
nnoremap <leader>dr  :lua require('dap').repl.open({}, 'tab')<cr>
nnoremap <leader>de  :lua require('dap').set_exception_breakpoints({"all"})<cr>
nnoremap <leader>da  :lua require('config/debug-helper').attach()<cr>
nnoremap <leader>dh  :lua require('dap.ui.widgets').hover()<cr>
vnoremap <leader>dh  :lua require('dap.ui.widgets').visual_hover()<cr>
nnoremap <leader>dv  :lua local widgets=require('dap.ui.widgets');widgets.centered_float(widgets.scopes)<cr>gg

augroup customDAP
  autocmd!
  autocmd FileType dap-repl lua require('dap.ext.autocompl').attach()
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""
"" Packer Manager (Packer)
"""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>pi :PackerInstall<cr>
nnoremap <leader>pu :PackerSync<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Hop
"""""""""""""""""""""""""""""""""""""""""""""""""

" 2-character Sneak (default)
nmap <leader>k <cmd>HopWord<cr>
nmap <leader>j <cmd>HopLine<cr>
nmap <leader>l <cmd>HopChar1<cr>
" visual-mode
xmap <leader>k <cmd>HopWord<cr>
xmap <leader>j <cmd>HopLine<cr>
xmap <leader>l <cmd>HopChar1<cr>
" operator-pending-mode
omap <leader>k <cmd>HopWord<cr>
omap <leader>j <cmd>HopLine<cr>
omap <leader>l <cmd>HopChar1<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Vimux
"""""""""""""""""""""""""""""""""""""""""""""""""

" Prompt for a command to run
nnoremap <leader>vv :VimuxPromptCommand<cr>
" Run last command executed by VimuxRunCommand
nnoremap <leader>vl :VimuxRunLastCommand<cr>
" Inspect runner pane
nnoremap <leader>vi :VimuxInspectRunner<cr>
" Close vim tmux runner opened by VimuxRunCommand
nnoremap <leader>vc :VimuxCloseRunner<cr>
" Interrupt any command running in the runner pane
nnoremap <leader>vp :VimuxInterruptRunner<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Delimitmate
"""""""""""""""""""""""""""""""""""""""""""""""""

let delimitMate_excluded_ft = "clojure"
let delimitMate_expand_cr = 2
let delimitMate_expand_space = 1
let delimitMate_expand_inside_quotes = 1

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Vim Test
"""""""""""""""""""""""""""""""""""""""""""""""""

let test#strategy = 'vimux'

nnoremap <leader>tt :TestNearest<CR>
nnoremap <leader>tf :TestFile<CR>
nnoremap <leader>ta :TestSuite<CR>
nnoremap <leader>tl :TestLast<CR>
nnoremap <leader>tv :TestVisit<CR>


