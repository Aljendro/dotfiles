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
"" Ultisnips
"""""""""""""""""""""""""""""""""""""""""""""""""

let g:UltiSnipsRemoveSelectModeMappings = 0

let snippetPath=$DOTFILES_DIR.'/ansible/roles/vim/files/snippets/'
let g:UltiSnipsSnippetDirectories=[snippetPath]

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

nnoremap <localleader>f :<C-U>NERDTreeFind<cr>
nnoremap <localleader>d :<C-U>NERDTreeToggle<cr>

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

" Open up Fugitive in a tab
nnoremap <leader>gdd :<C-U>tab G<cr>
" Create diffsplit
nnoremap <leader>gds :<C-U>tab split<cr>:<C-U>Gvdiffsplit<cr>
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
"" Fuzzy Finder (Telescope)
"""""""""""""""""""""""""""""""""""""""""""""""""
let g:fzf_command_prefix = 'F'
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.9 } }
let g:fzf_preview_window = ['right:60%', 'ctrl-/']

" Do not search the file path with rip grep
" (using with_preview 'options' parameter)
command! -bang -nargs=* FARg
      \ call fzf#vim#grep(
      \   'rg --multiline --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
      \   fzf#vim#with_preview({'options': '--delimiter=: --nth=4..'}, 'right'), <bang>0)

nnoremap <leader>sp    <cmd>lua require('telescope.builtin').resume()<cr>
nnoremap <leader>sf    <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>sa    <cmd>FRg<cr>
nnoremap <leader>sA    <cmd>FARg<cr>
nnoremap <leader>sgg   <cmd>lua require('telescope.builtin').grep_string({use_regex=true, search=''})<left><left><left>
nnoremap <leader>ss    <cmd>lua require('telescope.builtin').current_buffer_fuzzy_find({skip_empty_lines=true})<cr>
nnoremap <leader>sgf   <cmd>lua require('telescope.builtin').git_files()<cr>
nnoremap <leader>sgcb  <cmd>lua require('telescope.builtin').git_bcommits()<cr>
nnoremap <leader>sgcp  <cmd>lua require('telescope.builtin').git_commits()<cr>
nnoremap <leader>sgb   <cmd>lua require('telescope.builtin').git_branches()<cr>
nnoremap <leader>sgst  <cmd>lua require('telescope.builtin').git_status()<cr>
nnoremap <leader>sgsta <cmd>lua require('telescope.builtin').git_stash()<cr>
nnoremap <leader>sb    <cmd>lua require('telescope.builtin').buffers({sort_mru=true})<cr>
nnoremap <leader>sht   <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>sc    <cmd>lua require('telescope.builtin').commands()<cr>
nnoremap <leader>sq    <cmd>lua require('telescope.builtin').quickfix({ignore_filename=false})<cr>
nnoremap <leader>slq   <cmd>lua require('telescope.builtin').loclist({ignore_filename=false})<cr>
nnoremap <leader>sof   <cmd>lua require('telescope.builtin').oldfiles()<cr>
nnoremap <leader>s/    <cmd>lua require('telescope.builtin').search_history()<cr>
nnoremap <leader>s:    <cmd>lua require('telescope.builtin').command_history()<cr>
vnoremap <leader>s:    <cmd>lua require('telescope.builtin').command_history()<cr>
nnoremap <leader>svo   <cmd>lua require('telescope.builtin').vim_options()<cr>
nnoremap <leader>stm   <cmd>lua require('telescope.builtin').man_pages()<cr>
nnoremap <leader>stt   <cmd>lua require('telescope.builtin').treesitter()<cr>
nnoremap <leader>sm    <cmd>lua require('telescope.builtin').marks()<cr>
nnoremap <leader>sr    <cmd>lua require('telescope.builtin').registers()<cr>
nnoremap <leader>sk    <cmd>lua require('telescope.builtin').keymaps()<cr>
nnoremap <leader>stf   <cmd>lua require('telescope.builtin').filetypes()<cr>
nnoremap <leader>sj    <cmd>lua require('telescope.builtin').jumplist({ignore_filename=false})<cr>
nnoremap <leader>sla   <cmd>lua require('telescope.builtin').lsp_code_actions()<cr>
nnoremap <leader>slra  <cmd>lua require('telescope.builtin').lsp_range_code_actions()<cr>
nnoremap <leader>slds  <cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>
nnoremap <leader>slps  <cmd>lua require('telescope.builtin').lsp_workspace_symbols({query=''})<left><left><left>
nnoremap <leader>sldd  <cmd>lua require('telescope.builtin').lsp_document_diagnostics()<cr>
nnoremap <leader>slpd  <cmd>lua require('telescope.builtin').lsp_workspace_diagnostics()<cr>
nnoremap <leader>snc   <cmd>lua require('telescope').extensions.neoclip.default()<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
"" LSP Client
"""""""""""""""""""""""""""""""""""""""""""""""""

augroup customLSP
  autocmd!
  " Update signature help on jump placeholder.
  " autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  " Highlight the symbol and its references when holding the cursor.
  " autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""
"" DAP Client
"""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>dd  <cmd>lua require('dap').toggle_breakpoint()<cr>
nnoremap <leader>dD  <cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>
nnoremap <leader>dj  <cmd>lua require('dap').step_into()<cr>
nnoremap <leader>dk  <cmd>lua require('dap').step_out()<cr>
nnoremap <leader>dl  <cmd>lua require('dap').step_over()<cr>
nnoremap <leader>dC  <cmd>lua require('dap').run_to_cursor()<cr>
nnoremap <leader>d;  <cmd>lua require('dap').down()<cr>
nnoremap <leader>dh  <cmd>lua require('dap').up()<cr>
nnoremap <leader>dc  <cmd>lua require('dap').continue()<cr>
nnoremap <leader>ds  <cmd>lua require('dap').close()<cr>
nnoremap <leader>dl  <cmd>lua require('dap').run_last()<cr>
nnoremap <leader>dr  <cmd>lua require('dap').repl.open({}, 'tab')<cr>
nnoremap <leader>de  <cmd>lua require('dap').set_exception_breakpoints({"all"})<cr>
nnoremap <leader>da  <cmd>lua require('debug-helper').attach()<cr>
nnoremap <leader>dh  <cmd>lua require('dap.ui.widgets').hover()<cr>
vnoremap <leader>dh  <cmd>lua require('dap.ui.widgets').visual_hover()<cr>
nnoremap <leader>dv  <cmd>lua local widgets=require('dap.ui.widgets');widgets.centered_float(widgets.scopes)<cr>gg
nnoremap <leader>dtc <cmd>lua require('telescope').extensions.dap.commands({})<cr>
nnoremap <leader>dtb <cmd>lua require('telescope').extensions.dap.list_breakpoints({})<cr>
nnoremap <leader>dtv <cmd>lua require('telescope').extensions.dap.variables({})<cr>
nnoremap <leader>dtf <cmd>lua require('telescope').extensions.dap.frames({})<cr>

augroup customLSP
  autocmd!
  autocmd FileType dap-repl lua require('dap.ext.autocompl').attach()
augroup END


"""""""""""""""""""""""""""""""""""""""""""""""""
"" Sneak
"""""""""""""""""""""""""""""""""""""""""""""""""

" 2-character Sneak (default)
nmap <leader>k <cmd>HopWord<cr>
nmap <leader>j <cmd>HopLine<cr>
" visual-mode
xmap <leader>k <cmd>HopWord<cr>
xmap <leader>j <cmd>HopLine<cr>
" operator-pending-mode
omap <leader>k <cmd>HopWord<cr>
omap <leader>j <cmd>HopLine<cr>

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
