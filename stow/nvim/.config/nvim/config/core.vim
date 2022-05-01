" The core settings and keybindings in neovim
"
" Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
"

"""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""" Settings """"""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on
colorscheme tokyonight
match errorMsg /\s\+$/

let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0
let g:node_host_prog = expand("~/.nvm/versions/node/v14.19.1/bin/neovim-node-host")
let g:python3_host_prog = expand("/usr/bin/python3")

let g:loaded_netrwPlugin = 1
let g:loaded_tutor_mode_plugin = 1

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
set list
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
set showtabline=2
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
" Quick Grep and Location/Quickfix List opens
cnoreabbrev <expr> grep CommandAbbreviation('grep', "silent grep  \| copen<left><left><left><left><left><left><left><left>")
cnoreabbrev <expr> lgrep CommandAbbreviation('lgrep', "silent lgrep  <C-r>=expand('%:p')<cr> \| lopen<C-b><right><right><right><right><right><right><right><right><right><right><right><right><right>")
noreabbrev --ml --multiline --multiline-dotall
" Non Greedy *
cnoreabbrev *? <left>\{-}<C-r>=EatChar('\s')<cr>
" Always open help in new tab
cnoreabbrev <expr> tah CommandAbbreviation('tah', 'tab help') . ' '
" Change filetype
cnoreabbrev <expr> ft CommandAbbreviation('ft', 'set ft=')
" Split line by a character
cnoreabbrev <expr> sl CommandAbbreviation('sl', 's/\v()/\r/gc<left><left><left><left><left><left><left>')

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Options
"""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>oh  :set cursorcolumn!<cr>:set cursorcolumn?<cr>
nnoremap <leader>of  :set foldenable!<cr>:set foldenable?<cr>
nnoremap <leader>ol  :set lazyredraw!<cr>:set lazyredraw?<cr>
nnoremap <leader>on  :set number!<cr>:set number?<cr>
nnoremap <leader>or  :set relativenumber!<cr>:set relativenumber?<cr>
nnoremap <leader>ob  :set scrollbind!<cr>:set scrollbind?<cr>
nnoremap <leader>osc :set spell!<cr>:set spell?<cr>
nnoremap <leader>oss :lua ToggleSmoothScroll()<cr>
nnoremap <leader>ow  :set wrap!<cr>:set wrap?<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Terminal
"""""""""""""""""""""""""""""""""""""""""""""""""

" tnoremap <Esc> <C-\><C-n>
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Saves
"""""""""""""""""""""""""""""""""""""""""""""""""

" Faster saving
nnoremap <leader>q :bd!<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Quickfix
"""""""""""""""""""""""""""""""""""""""""""""""""

" Move between quickfix list easily
nnoremap <M-h> :cNfile<cr>zz
nnoremap <M-j> :cnext<cr>zz
nnoremap <M-k> :cprevious<cr>zz
nnoremap <M-l> :cnfile<cr>zz

" Move between location list easily
nnoremap <M-m> :lnext<cr>zz
nnoremap <M-,> :lprevious<cr>zz

" Remove folds for all files in quickfix
cnoreabbrev <expr> qnf CommandAbbreviation('qnf', 'cfdo set nofoldenable')

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

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Search
"""""""""""""""""""""""""""""""""""""""""""""""""

" Easier search and/or replace
nnoremap <leader>/r :%s//gci<Left><Left><Left><Left>
" Count the number of possible replacements (occurrences and lines)
nnoremap <leader>/c :%s///gn<cr>

" Change word under cursor giving the ability to reapply with .
xmap <leader>/w *Ncgn
nmap <leader>/w g*cgn

" Visual mode pressing * or # searches for the current selection
xnoremap <silent> * :call GetSelectedText()<cr>/<C-R>=@/<cr><cr>
xnoremap <silent> # :call GetSelectedText()<cr>?<C-R>=@/<cr><cr>

" Maintain position when you hit * or #
nnoremap * :keepjumps normal! mi*`i<cr>
nnoremap g* :keepjumps normal! mig*`i<cr>
nnoremap # :keepjumps normal! mi#`i<cr>
nnoremap g# :keepjumps normal! mig#`i<cr>

" Center cursor when searching
nnoremap n nzzzv
nnoremap N Nzzzv

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Args
"""""""""""""""""""""""""""""""""""""""""""""""""

" Move between args easily
nnoremap sm :previous<cr>
nnoremap s, :next<cr>
nnoremap sn :first<cr>
nnoremap s. :last<cr>

" Add current buffer to the argument list
nnoremap saa :$argadd<cr>
" Quickly add to arg list
nnoremap sad :argd<cr>
nnoremap saD :%argd<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Buffers
"""""""""""""""""""""""""""""""""""""""""""""""""

" Move between buffers easily
nnoremap su :bprevious<cr>
nnoremap si :bnext<cr>

" Quickly delete buffer
nnoremap sd :bdelete<cr>
nnoremap sD :bdelete!<cr>

" Toggle pinned buffers
nnoremap sp  :call Toggle('aljendro_is_buffer_pinned', 'Buffer pinned: ')<cr>
" Delete unpinned buffers
nnoremap sbd :bufdo if get(b:, 'aljendro_is_buffer_pinned', 0) == 0 \| exec 'bd' \| endif<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""
"" Tabs
"""""""""""""""""""""""""""""""""""""""""""""""""

" Move between tabs easily
nnoremap sy gT
nnoremap so gt
" Move a window into a new tabpage
nnoremap <leader>tw <C-w>T
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
xnoremap <leader>fo zozz
nnoremap <leader>fO zOzz
xnoremap <leader>fO zOzz
nnoremap <leader>fc zczz
xnoremap <leader>fc zczz
nnoremap <leader>fC zCzz
xnoremap <leader>fC zCzz
nnoremap <leader>fe mazMzv`azczOzz
" Reset Folds
nnoremap <leader>fr zx

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
nnoremap <leader>pp :profile start profile-all.local.txt \| profile file * \| profile func *<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Macros
"""""""""""""""""""""""""""""""""""""""""""""""""

" Easier macro execution
nnoremap <silent> <leader>m :call RecordMacro()<cr>
xnoremap <expr> <leader>e ':norm! @' . nr2char(getchar()) . '<cr>'
nnoremap Q @@
xnoremap Q :norm! @@<cr>

nnoremap <silent> <leader>an :call AppendNewlineToRegister()<cr>

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
xnoremap < <gv
xnoremap > >gv

" Next character remap
nnoremap <leader>; ;
xnoremap <leader>; ;

" Use the . to execute once for each line of a visual selection
xnoremap . :normal .<cr>

" Faster shifting
nnoremap <Left> zH
nnoremap <Right> zL

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
nmap <leader>) ysiw)
nmap <leader>} ysiw}

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
nnoremap <leader>gg :tab Git<cr>
" Create diffsplit
nnoremap <leader>gd :tab split<cr>:Gvdiffsplit<cr>
" Load changes into quickfix list
nnoremap <leader>gq :Git difftool<cr>:cclose<cr>
" Load diffs into tabs
nnoremap <leader>gD :Git difftool -y<cr>:cclose<cr>
" Open merge conflicts in different tabs
nnoremap <leader>gC :Git mergetool -y<cr>:cclose<cr>
" Open git blame with commit and author
nmap <leader>gb :Git blame<cr>A
" Refresh difftool
nnoremap <leader>gu :diffupdate<cr>
" Choose left buffer
nnoremap <expr> <leader>gj ':diffget //2/' . GetFilePathFromGitRoot(expand('%')) . '<cr>'
" Choose the right buffer
nnoremap <expr> <leader>gk ':diffget //3/' . GetFilePathFromGitRoot(expand('%')) . '<cr>'

cnoreabbrev <expr> gf CommandAbbreviation('gf', 'Git fetch origin')
cnoreabbrev <expr> gb CommandAbbreviation('gb', 'Git branch')
cnoreabbrev <expr> gbd CommandAbbreviation('gbd', 'Git branch -d')
cnoreabbrev <expr> gbdr CommandAbbreviation('gbdr', 'Git push origin --delete')
cnoreabbrev <expr> gpl CommandAbbreviation('gpl', 'Git pull')
cnoreabbrev <expr> ggpull CommandAbbreviation('ggpull', 'Git pull origin <C-R>=FugitiveHead()<cr>')
cnoreabbrev <expr> gp CommandAbbreviation('gp', 'Git push')
cnoreabbrev <expr> ggpush CommandAbbreviation('ggpush', 'Git push origin <C-R>=FugitiveHead()<cr>')
cnoreabbrev <expr> gco CommandAbbreviation('gco', 'Git checkout')
cnoreabbrev <expr> gcb CommandAbbreviation('gcb', 'Git checkout -b')
cnoreabbrev <expr> gcd CommandAbbreviation('gcd', 'Git checkout develop')
cnoreabbrev <expr> gcm CommandAbbreviation('gcm', 'Git checkout master')
cnoreabbrev <expr> gac CommandAbbreviation('gac', 'Git commit -a -m')
cnoreabbrev <expr> gsta CommandAbbreviation('gsta', 'Git stash push -u -m')
cnoreabbrev <expr> gstd CommandAbbreviation('gstd', 'Git stash drop')
cnoreabbrev <expr> gstl CommandAbbreviation('gstl', 'Git stash list')
cnoreabbrev <expr> gstp CommandAbbreviation('gstp', 'Git stash pop')

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Fuzzy Finder (Telescope)
"""""""""""""""""""""""""""""""""""""""""""""""""

let g:fzf_command_prefix = 'F'
let g:fzf_layout = { 'window': { 'width': 0.99, 'height': 0.99 } }
let g:fzf_preview_window = ['up:40%:hidden', 'ctrl-/']

nnoremap ;/    :lua require('telescope.builtin').search_history()<cr>
nnoremap ;;    :lua require('telescope.builtin').command_history()<cr>
xnoremap ;;    :lua require('telescope.builtin').command_history()<cr>
nnoremap ;a    :FRg<cr>
nnoremap ;A    :lua require('telescope.builtin').autocommands()<cr>
nnoremap ;b    :lua require('telescope.builtin').buffers({sort_mru=true})<cr>
nnoremap ;B    :lua require('telescope.builtin').builtin()<cr>
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
nnoremap ;ll   :lua require('telescope.builtin').loclist()<cr>
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
nnoremap ;p    :lua require('telescope.builtin').pickers()<cr>
nnoremap ;q    :lua require('telescope.builtin').quickfix()<cr>
nnoremap ;r    :lua require('telescope.builtin').resume()<cr>
nnoremap ;R    :lua require('telescope.builtin').registers()<cr>
nnoremap ;s    :lua require('telescope.builtin').current_buffer_fuzzy_find({skip_empty_lines=true})<cr>
nnoremap ;t    :lua require('telescope.builtin').treesitter()<cr>
nnoremap ;vf   :lua require('telescope.builtin').filetypes()<cr>
nnoremap ;vo   :lua require('telescope.builtin').vim_options()<cr>
nnoremap ;w    :Telescope grep_string<cr>
xnoremap ;w    :call GetSelectedText()<cr>:Telescope grep_string use_regex=false search=<C-R>=@/<cr><cr>

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
xnoremap <leader>dh  :lua require('dap.ui.widgets').visual_hover()<cr>
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
nnoremap <leader>vq :VimuxCloseRunner<cr>
" Stop the process
nnoremap <leader>vs :VimuxInterruptRunner<cr>
" Clear Pane
nnoremap <leader>vc :VimuxClearTerminalScreen<cr>
" Clear history
nnoremap <leader>vC :VimuxClearRunnerHistory<cr>
" Zoom Runner
nnoremap <leader>vz :VimuxZoomRunner<cr>

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

nnoremap <leader>tt :TestNearest<cr>
nnoremap <leader>tf :TestFile<cr>
nnoremap <leader>ta :TestSuite<cr>
nnoremap <leader>tl :TestLast<cr>
nnoremap <leader>tv :TestVisit<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Harpoon
"""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>sa :lua require("harpoon.mark").add_file()<cr>
nnoremap <leader>sA :lua require("harpoon.ui").toggle_quick_menu()<cr>
nnoremap <leader>sm :lua require("harpoon.ui").nav_file(1)<cr>
nnoremap <leader>s, :lua require("harpoon.ui").nav_file(2)<cr>
nnoremap <leader>s. :lua require("harpoon.ui").nav_file(3)<cr>
nnoremap <leader>sj :lua require("harpoon.ui").nav_file(4)<cr>
nnoremap <leader>sk :lua require("harpoon.ui").nav_file(5)<cr>
nnoremap <leader>sl :lua require("harpoon.ui").nav_file(6)<cr>
nnoremap <leader>su :lua require("harpoon.ui").nav_file(7)<cr>
nnoremap <leader>si :lua require("harpoon.ui").nav_file(8)<cr>
nnoremap <leader>so :lua require("harpoon.ui").nav_file(9)<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" JQ
"""""""""""""""""""""""""""""""""""""""""""""""""

cnoreabbrev <expr> jq CommandAbbreviation('jq', "%!jq ''<left>", "!jq ''<left>")
cnoreabbrev <expr> jqc CommandAbbreviation('jqc', "%!jq -c ''<left>", "!jq -c ''<left>")
cnoreabbrev <expr> jqs CommandAbbreviation('jqs', "%!jq -s ''<left>", "!jq -s ''<left>")
cnoreabbrev <expr> jqs CommandAbbreviation('jqcs', "%!jq -c -s ''<left>", "!jq -c -s ''<left>")

"""""""""""""""""""""""""""""""""""""""""""""""""
"" NrrwRgn
"""""""""""""""""""""""""""""""""""""""""""""""""

let g:nrrw_topbot_leftright = 'botright'

xmap <leader>z <Plug>NrrwrgnDo

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Tabularize
"""""""""""""""""""""""""""""""""""""""""""""""""

" Fast column formatting
cnoreabbrev <expr> t CommandAbbreviation('t', "Tab /")

"""""""""""""""""""""""""""""""""""""""""""""""""
"" Nvim-tree
"""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap ;d :NvimTreeFindFile<cr>
nnoremap ;D :NvimTreeToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" vim-visual-multi (multiple cursors)
"""""""""""""""""""""""""""""""""""""""""""""""""

let g:VM_leader = '<bslash>'
let g:VM_mouse_mappings = v:true

