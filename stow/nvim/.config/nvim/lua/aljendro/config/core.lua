-- The core settings and keybindings in neovim
--
-- Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
--

----------------------------------------------------------------------------
-- Surround
----------------------------------------------------------------------------

vim.api.nvim_set_keymap('n', [[<leader>']], [[ysiw']], { silent = true })
vim.api.nvim_set_keymap('n', [[<leader>"]], [[ysiw"]], { silent = true })
vim.api.nvim_set_keymap('n', [[<leader>`]], [[ysiw`]], { silent = true })
vim.api.nvim_set_keymap('n', [[<leader>)]], [[ysiw)]], { silent = true })
vim.api.nvim_set_keymap('n', [[<leader>}]], [[ysiw}]], { silent = true })

----------------------------------------------------------------------------
-- Ultisnips
----------------------------------------------------------------------------

vim.g.UltiSnipsRemoveSelectModeMappings = false

vim.g.snippetPath = os.getenv('HOME') .. '/.config/nvim/ultisnips'
vim.g.UltiSnipsSnippetDirectories = { vim.g.snippetPath }

----------------------------------------------------------------------------
-- Git Plugins (Fugitive, Gitgutter, etc.)
----------------------------------------------------------------------------

-- Open up Fugitive in a tab
vim.api.nvim_set_keymap('n', '<leader>gg', ':tab Git<cr>', { noremap = true })
-- Create diffsplit
vim.api.nvim_set_keymap('n', '<leader>gd', ':tab split<cr>:Gvdiffsplit<cr>', { noremap = true })
-- Load changes into quickfix list
vim.api.nvim_set_keymap('n', '<leader>gq', ':Git difftool<cr>:cclose<cr>', { noremap = true })
-- Load diffs into tabs
vim.api.nvim_set_keymap('n', '<leader>gD', ':Git difftool -y<cr>:cclose<cr>', { noremap = true })
-- Open git blame with commit and author
vim.api.nvim_set_keymap('n', '<leader>gb', ':Git blame<cr>A', { silent = true })
-- Refresh difftool
vim.api.nvim_set_keymap('n', '<leader>gu', ':diffupdate<cr>', { noremap = true })
-- Choose left buffer
vim.api.nvim_set_keymap('n', '<leader>gh', ':diffget //2<cr>', { noremap = true })
-- Choose the right buffer
vim.api.nvim_set_keymap('n', '<leader>gl', ':diffget //3<cr>', { noremap = true })

-- Traverse git merge conflict markers
vim.api.nvim_set_keymap('n', '[n', ':call v:lua.DiffContext(true)<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', ']n', ':call v:lua.DiffContext(false)<CR>', { noremap = true })

--------------------------------------------------------------------------------
-- Telescope
--------------------------------------------------------------------------------

vim.api.nvim_set_keymap('n', ';/', [[:lua require('telescope.builtin').search_history()<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', ';;', [[:lua require('telescope.builtin').command_history()<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('x', ';;', [[:lua require('telescope.builtin').command_history()<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', ';a', [[:lua require('telescope.builtin').autocommands()<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', ';b', [[:lua require('telescope.builtin').buffers({sort_mru=true})<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', ';B', [[:lua require('telescope.builtin').builtin()<cr>]], { noremap = true })
vim.api.nvim_set_keymap('n', ';c', [[:lua require('telescope.builtin').commands()<cr>]], { noremap = true })
vim.api.nvim_set_keymap('n', ';f', [[:lua require('telescope.builtin').find_files({hidden=true})<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', ';gc', [[:lua require('telescope.builtin').git_bcommits()<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', ';gC', [[:lua require('telescope.builtin').git_commits()<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', ';gb', [[:lua require('telescope.builtin').git_branches()<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', ';gf', [[:lua require('telescope.builtin').git_files()<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', ';gg', [[:lua require('telescope.builtin').live_grep()<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', ';gs', [[:lua require('telescope.builtin').git_stash()<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', ';h', [[:lua require('telescope.builtin').help_tags()<cr>]], { noremap = true })
vim.api.nvim_set_keymap('n', ';j', [[:lua require('telescope.builtin').jumplist({ignore_filename=false})<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', ';k', [[:lua require('telescope.builtin').keymaps()<cr>]], { noremap = true })
vim.api.nvim_set_keymap('n', ';ll', [[:lua require('telescope.builtin').loclist()<cr>]], { noremap = true })
-- TODO: Figure out why this is not working with visual selection
-- vnoremap ;l :lua require('telescope.builtin').lsp_range_code_actions()<cr>
vim.api.nvim_set_keymap('n', ';ld', [[:lua require('telescope.builtin').diagnostics({bufnr=0})<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', ';lm', [[:lua require('telescope.builtin').man_pages()<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', ';ls', [[:lua require('telescope.builtin').lsp_document_symbols()<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', ';lD', [[:lua require('telescope.builtin').diagnostics()<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', ';lS',
  [[:lua require('telescope.builtin').lsp_workspace_symbols({query=''})<left><left><left>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', ';m', [[:lua require('telescope.builtin').marks()<cr>]], { noremap = true })
vim.api.nvim_set_keymap('n', ';n', [[:lua require('telescope').extensions.neoclip.default()<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', ';of', [[:lua require('telescope.builtin').oldfiles()<cr>]], { noremap = true })
vim.api.nvim_set_keymap('n', ';p', [[:lua require('telescope.builtin').pickers()<cr>]], { noremap = true })
vim.api.nvim_set_keymap('n', ';q', [[:lua require('telescope.builtin').quickfix()<cr>]], { noremap = true })
vim.api.nvim_set_keymap('n', ';r', [[:lua require('telescope.builtin').resume()<cr>]], { noremap = true })
vim.api.nvim_set_keymap('n', ';R', [[:lua require('telescope.builtin').registers()<cr>]], { noremap = true })
vim.api.nvim_set_keymap('n', ';s',
  [[:lua require('telescope.builtin').current_buffer_fuzzy_find({skip_empty_lines=true})<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', ';t', [[:lua require('telescope.builtin').treesitter()<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', ';vf', [[:lua require('telescope.builtin').filetypes()<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', ';vo', [[:lua require('telescope.builtin').vim_options()<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', ';w', [[:Telescope grep_string<cr>]], { noremap = true })
vim.api.nvim_set_keymap('x', ';w',
  [[:call v:lua.GetSelectedTextGrep()<cr>:Telescope grep_string additional_args={'-F'} search=<C-R>=@/<cr><cr>]],
  { noremap = true })

----------------------------------------------------------------------------
-- DAP Client
----------------------------------------------------------------------------

vim.api.nvim_set_keymap('n', '<leader>dd', [[:lua require('dap').toggle_breakpoint()<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dD',
  [[:lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dj', [[:lua require('dap').step_into()<cr>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dk', [[:lua require('dap').step_out()<cr>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dl', [[:lua require('dap').step_over()<cr>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dC', [[:lua require('dap').run_to_cursor()<cr>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>d;', [[:lua require('dap').down()<cr>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dh', [[:lua require('dap').up()<cr>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dc', [[:lua require('dap').continue()<cr>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>ds', [[:lua require('dap').close()<cr>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dl', [[:lua require('dap').run_last()<cr>]], { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dr', [[:lua require('dap').repl.open({}, 'tab')<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>de', [[:lua require('dap').set_exception_breakpoints({"all"})<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>da', [[:lua require('config/plugins/debug-helper').attach()<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dh', [[:lua require('dap.ui.widgets').hover()<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('x', '<leader>dh', [[:lua require('dap.ui.widgets').visual_hover()<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dv',
  [[:lua local widgets=require('dap.ui.widgets');widgets.centered_float(widgets.scopes)<cr>gg]],
  { noremap = true })

----------------------------------------------------------------------------
-- Packer Manager (Packer)
----------------------------------------------------------------------------

vim.api.nvim_set_keymap('n', '<leader>pi', ':PackerInstall<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>pu', ':PackerSync<cr>', { noremap = true })

--------------------------------------------------------------------------------
-- Hop
--------------------------------------------------------------------------------

-- 1-character
vim.api.nvim_set_keymap('n', '<leader>k', '<cmd>HopWord<cr>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>j', '<cmd>HopLine<cr>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>l', '<cmd>HopChar1<cr>', { silent = true })
-- visual-mode
vim.api.nvim_set_keymap('x', '<leader>k', '<cmd>HopWord<cr>', { silent = true })
vim.api.nvim_set_keymap('x', '<leader>j', '<cmd>HopLine<cr>', { silent = true })
vim.api.nvim_set_keymap('x', '<leader>l', '<cmd>HopChar1<cr>', { silent = true })
-- operator-pending-mode
vim.api.nvim_set_keymap('o', '<leader>k', '<cmd>HopWord<cr>', { silent = true })
vim.api.nvim_set_keymap('o', '<leader>j', '<cmd>HopLine<cr>', { silent = true })
vim.api.nvim_set_keymap('o', '<leader>l', '<cmd>HopChar1<cr>', { silent = true })

----------------------------------------------------------------------------
-- Vimux
----------------------------------------------------------------------------

-- Prompt for a command to run
vim.api.nvim_set_keymap('n', '<leader>vv', ':VimuxPromptCommand<cr>', { noremap = true })
-- Run last command executed by VimuxRunCommand
vim.api.nvim_set_keymap('n', '<leader>vl', ':VimuxRunLastCommand<cr>', { noremap = true })
-- Inspect runner pane
vim.api.nvim_set_keymap('n', '<leader>vi', ':VimuxInspectRunner<cr>', { noremap = true })
-- Close vim tmux runner opened by VimuxRunCommand
vim.api.nvim_set_keymap('n', '<leader>vq', ':VimuxCloseRunner<cr>', { noremap = true })
-- Stop the process
vim.api.nvim_set_keymap('n', '<leader>vs', ':VimuxInterruptRunner<cr>', { noremap = true })
-- Clear Pane
vim.api.nvim_set_keymap('n', '<leader>vc', ':VimuxClearTerminalScreen<cr>', { noremap = true })
-- Clear history
vim.api.nvim_set_keymap('n', '<leader>vC', ':VimuxClearRunnerHistory<cr>', { noremap = true })
-- Zoom Runner
vim.api.nvim_set_keymap('n', '<leader>vz', ':VimuxZoomRunner<cr>', { noremap = true })

----------------------------------------------------------------------------
-- Vim Test
----------------------------------------------------------------------------

-- let test#strategy = 'vimux'

vim.api.nvim_set_keymap('n', '<leader>tt', ':TestNearest<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>tf', ':TestFile<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>ta', ':TestSuite<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>tl', ':TestLast<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>tv', ':TestVisit<cr>', { noremap = true })

--------------------------------------------------------------------------------
-- Harpoon
--------------------------------------------------------------------------------

vim.api.nvim_set_keymap('n', '<leader>sa', ':lua require("harpoon.mark").add_file()<cr>',
  { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>sA', ':lua require("harpoon.ui").toggle_quick_menu()<cr>',
  { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>sm', ':lua require("harpoon.ui").nav_file(1)<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>s,', ':lua require("harpoon.ui").nav_file(2)<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>s.', ':lua require("harpoon.ui").nav_file(3)<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>sj', ':lua require("harpoon.ui").nav_file(4)<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>sk', ':lua require("harpoon.ui").nav_file(5)<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>sl', ':lua require("harpoon.ui").nav_file(6)<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>su', ':lua require("harpoon.ui").nav_file(7)<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>si', ':lua require("harpoon.ui").nav_file(8)<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>so', ':lua require("harpoon.ui").nav_file(9)<cr>', { noremap = true })

----------------------------------------------------------------------------
-- NrrwRgn
----------------------------------------------------------------------------

vim.g.nrrw_rgn_vert = true
vim.g.nrrw_rgn_resize_window = 'relative'

vim.api.nvim_set_keymap('x', '<leader>z', '<Plug>NrrwrgnDo', { silent = true })

--------------------------------------------------------------------------------
--  Nvim-tree
--------------------------------------------------------------------------------

vim.api.nvim_set_keymap('n', ';df', ':NvimTreeFindFileToggle<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', ';dd', ':NvimTreeToggle<cr>', { noremap = true })

--------------------------------------------------------------------------------
-- vim-visual-multi (multiple cursors)
--------------------------------------------------------------------------------

-- Settings
vim.g.VM_theme = 'neon'
vim.g.VM_silent_exit = true

-- Keybindings
vim.g.VM_leader = '<bslash>'
vim.g.VM_mouse_mappings = true


vim.cmd([[

" Code signature
iabbrev @@ Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
" Quick Grep and Location/Quickfix List opens
cnoreabbrev <expr> grep v:lua.CommandAbbreviation('grep', "silent grep  \| copen<left><left><left><left><left><left><left><left>")
cnoreabbrev <expr> lgrep v:lua.CommandAbbreviation('lgrep', "silent lgrep  <C-r>=expand('%:p')<cr> \| lopen<C-b><right><right><right><right><right><right><right><right><right><right><right><right><right>")
noreabbrev _ml --multiline
noreabbrev _mla --multiline --multiline-dotall
" Non Greedy *
cnoreabbrev *? <left>\{-}<C-r>=v:lua.EatChar('\s')<cr>
" Always open help in new tab
cnoreabbrev <expr> tah v:lua.CommandAbbreviation('tah', 'tab help') . ' '
" Change filetype
cnoreabbrev <expr> ft v:lua.CommandAbbreviation('ft', 'set ft=')
" Split line by a character

cnoreabbrev <expr> qnf v:lua.CommandAbbreviation('qnf', 'cfdo set nofoldenable')

cnoreabbrev <expr> wdt v:lua.CommandAbbreviation('wdt', 'windo diffthis')

highlight WinSeparator guifg=#999999

augroup customVim
      autocmd!
      " When editing a file, always jump to the last known cursor position.
      autocmd BufReadPost *
                        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
                        \ |   exe "normal! g`\""
                        \ | endif
      " Create a default session when vim leaves
      autocmd VimLeave * :call v:lua.MakeSession('default')
      " Open quickfix after command that populates it is run
      autocmd QuickFixCmdPost [^l]* cwindow
      autocmd QuickFixCmdPost l* lwindow
      " Highlight the movement selection
      autocmd TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=150 }
augroup END

let g:nremap = {'s': 'S'}
let g:xremap = {'s': 'S'}

cnoreabbrev <expr> gf v:lua.CommandAbbreviation('gf', 'Git fetch origin')
cnoreabbrev <expr> gb v:lua.CommandAbbreviation('gb', 'Git branch')
cnoreabbrev <expr> gbd v:lua.CommandAbbreviation('gbd', 'Git branch -d')
cnoreabbrev <expr> gbdr v:lua.CommandAbbreviation('gbdr', 'Git push origin --delete')
cnoreabbrev <expr> gpl v:lua.CommandAbbreviation('gpl', 'Git pull')
cnoreabbrev <expr> ggpull v:lua.CommandAbbreviation('ggpull', 'Git pull origin <C-R>=FugitiveHead()<cr>')
cnoreabbrev <expr> gp v:lua.CommandAbbreviation('gp', 'Git push')
cnoreabbrev <expr> ggpush v:lua.CommandAbbreviation('ggpush', 'Git push origin <C-R>=FugitiveHead()<cr>')
cnoreabbrev <expr> gco v:lua.CommandAbbreviation('gco', 'Git checkout')
cnoreabbrev <expr> gcb v:lua.CommandAbbreviation('gcb', 'Git checkout -b')
cnoreabbrev <expr> gcd v:lua.CommandAbbreviation('gcd', 'Git checkout develop')
cnoreabbrev <expr> gcm v:lua.CommandAbbreviation('gcm', 'Git checkout master')
cnoreabbrev <expr> gac v:lua.CommandAbbreviation('gac', 'Git commit -a -m')
cnoreabbrev <expr> gsta v:lua.CommandAbbreviation('gsta', 'Git stash push -u -m')
cnoreabbrev <expr> gstd v:lua.CommandAbbreviation('gstd', 'Git stash drop')
cnoreabbrev <expr> gstl v:lua.CommandAbbreviation('gstl', 'Git stash list')
cnoreabbrev <expr> gstp v:lua.CommandAbbreviation('gstp', 'Git stash pop')

highlight LspReference guifg=NONE guibg=#665c54 guisp=NONE gui=NONE cterm=NONE ctermfg=NONE ctermbg=59
highlight! link LspReferenceText LspReference
highlight! link LspReferenceRead LspReference
highlight! link LspReferenceWrite LspReference

augroup customDAP
  autocmd!
  autocmd FileType dap-repl lua require('dap.ext.autocompl').attach()
augroup END

cnoreabbrev <expr> jq v:lua.CommandAbbreviation('jq', "%!jq ''<left>", "!jq ''<left>")
cnoreabbrev <expr> jqc v:lua.CommandAbbreviation('jqc', "%!jq -c ''<left>", "!jq -c ''<left>")
cnoreabbrev <expr> jqs v:lua.CommandAbbreviation('jqs', "%!jq -s ''<left>", "!jq -s ''<left>")
cnoreabbrev <expr> jqs v:lua.CommandAbbreviation('jqcs', "%!jq -c -s ''<left>", "!jq -c -s ''<left>")

cnoreabbrev <expr> t v:lua.CommandAbbreviation('t', "Tab /")

]])
