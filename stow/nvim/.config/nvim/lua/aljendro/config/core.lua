-- The core settings and keybindings in neovim
--
-- Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
--

--------------------------------------------------------------------------------
------------------------------------ Settings ----------------------------------
--------------------------------------------------------------------------------

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.node_host_prog = vim.fn.expand(
  "~/.nvm/versions/node/v16.17.0/bin/neovim-node-host")
vim.g.python3_host_prog = vim.fn.expand("/usr/bin/python3")
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1

vim.opt.clipboard = { "unnamed" }
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.cursorline = true
vim.opt.dictionary:append("/usr/share/dict/words")
vim.opt.display = { "truncate" }
vim.opt.expandtab = true
vim.opt.fillchars = { diff = " ", fold = "." }
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
vim.opt.grepprg = [[rg --vimgrep --no-heading]]
vim.opt.ignorecase = true
vim.opt.iskeyword:append("-")
vim.opt.list = true
vim.opt.mouse = "a"
vim.opt.nrformats:remove("octal")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 1
vim.opt.shortmess:append("c")
vim.opt.showmode = false
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.updatetime = 100
vim.opt.virtualedit = { "block", "onemore" }
vim.opt.wrap = false
vim.opt.writebackup = false

--------------------------------------------------------------------------------
------------------------------------ Theme -------------------------------------
--------------------------------------------------------------------------------

require('tokyonight').setup({ dim_inactive = true })

--------------------------------------------------------------------------------
--------------------------- Configurations/Keybindings -------------------------
--------------------------------------------------------------------------------

vim.api.nvim_set_keymap('n', '<Bslash>', '<Nop>', {})
vim.api.nvim_set_keymap('n', '<space>', '<Nop>', {})
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Quick save
vim.api.nvim_set_keymap('n', '<leader>r',
  ":lua require('plenary.reload').reload_module('aljendro', true)<cr>:source $MYVIMRC<cr>",
  { noremap = true, silent = true })

----------------------------------------------------------------------------
-- Options
----------------------------------------------------------------------------

vim.api.nvim_set_keymap('n', '<leader>oh', ':set cursorcolumn!<cr>:set cursorcolumn?<cr>',
  { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>of', ':set foldenable!<cr>:set foldenable?<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>ol', ':set lazyredraw!<cr>:set lazyredraw?<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>on', ':set number!<cr>:set number?<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>or', ':set relativenumber!<cr>:set relativenumber?<cr>',
  { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>ob', ':set scrollbind!<cr>:set scrollbind?<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>osc', ':set spell!<cr>:set spell?<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>oss', ':lua ToggleSmoothScroll()<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>oww', ':set wrap!<cr>:set wrap?<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>ows', ':set wrapscan!<cr>:set wrapscan?<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>op', [[:call v:lua.Toggle('aljendro_is_buffer_pinned', 'Buffer pinned: ')<cr>]],
  { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>oP',
  [[mZ:bufdo call v:lua.ToggleOff('aljendro_is_buffer_pinned', 'Buffer pinned: ')<cr>`Z]],
  { noremap = true })

----------------------------------------------------------------------------
-- Terminal
----------------------------------------------------------------------------

vim.api.nvim_set_keymap('t', '<C-R>', [['<C-\><C-N>"' . nr2char(getchar()) . 'pi']],
  { expr = true, noremap = true })

----------------------------------------------------------------------------
-- Saves
----------------------------------------------------------------------------

-- Faster buffer delete quitting
vim.api.nvim_set_keymap('n', '<leader>q', ':bd!<cr>', { noremap = true })

----------------------------------------------------------------------------
-- Quickfix
----------------------------------------------------------------------------

-- Move between quickfix list easily
vim.api.nvim_set_keymap('n', '<M-h>', ':cNfile<cr>zz', { noremap = true })
vim.api.nvim_set_keymap('n', '<M-j>', ':cnext<cr>zz', { noremap = true })
vim.api.nvim_set_keymap('n', '<M-k>', ':cprevious<cr>zz', { noremap = true })
vim.api.nvim_set_keymap('n', '<M-l>', ':cnfile<cr>zz', { noremap = true })

-- Move between location list easily
vim.api.nvim_set_keymap('n', '<M-m>', ':lnext<cr>zz', { noremap = true })
vim.api.nvim_set_keymap('n', '<M-,>', ':lprevious<cr>zz', { noremap = true })

--------------------------------------------------------------------------------
-- Splits/Windows
--------------------------------------------------------------------------------

-- Only split
vim.api.nvim_set_keymap('n', 'ss', '<C-w>o', { noremap = true })

-- Tab split
vim.api.nvim_set_keymap('n', 'st', ':tab split<cr>', { noremap = true })

-- Vertical split
vim.api.nvim_set_keymap('n', 'sv', '<C-w>v', { noremap = true })

-- Close split
vim.api.nvim_set_keymap('n', 'sc', '<C-w>c', { noremap = true })

-- Move between windows easily
vim.api.nvim_set_keymap('n', 'sk', '<C-w><C-k>', { noremap = true })
vim.api.nvim_set_keymap('n', 'sj', '<C-w><C-j>', { noremap = true })
vim.api.nvim_set_keymap('n', 'sl', '<C-w><C-l>', { noremap = true })
vim.api.nvim_set_keymap('n', 'sh', '<C-w><C-h>', { noremap = true })

-- Move windows easily
vim.api.nvim_set_keymap('n', '<C-w>j', '<C-w>J', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-w>k', '<C-w>K', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-w>l', '<C-w>L', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-w>h', '<C-w>H', { noremap = true })

-- Resize windows
vim.api.nvim_set_keymap('n', '<M-d>', ':resize -4<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<M-e>', ':resize +4<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<M-s>', ':vertical resize +16<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<M-f>', ':vertical resize -16<cr>', { noremap = true })

----------------------------------------------------------------------------
-- Search
----------------------------------------------------------------------------

-- Easier search and/or replace
vim.api.nvim_set_keymap('n', '<leader>/r', ':%s//gci<Left><Left><Left><Left>', { noremap = true })
-- Count the number of possible replacements (occurrences and lines)
vim.api.nvim_set_keymap('n', '<leader>/c', ':%s///gn<cr>', { noremap = true })

-- Change word under cursor giving the ability to reapply with .
vim.api.nvim_set_keymap('x', '<leader>/w', '*Ncgn', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>/w', 'g*cgn', { silent = true })

-- Visual mode pressing * or # searches for the current selection
vim.api.nvim_set_keymap('x', '*', 'mi:call v:lua.GetSelectedText()<cr>/<C-R>=@/<cr><cr>`i',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '#', 'mi:call v:lua.GetSelectedText()<cr>?<C-R>=@/<cr><cr>`i',
  { noremap = true, silent = true })

-- Maintain position when you hit * or #
vim.api.nvim_set_keymap('n', '*', ':keepjumps normal! mi*`i<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', 'g*', ':keepjumps normal! mig*`i<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '#', ':keepjumps normal! mi#`i<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', 'g#', ':keepjumps normal! mig#`i<cr>', { noremap = true })

-- Center cursor when searching
vim.api.nvim_set_keymap('n', 'n', 'nzzzv', { noremap = true })
vim.api.nvim_set_keymap('n', 'N', 'Nzzzv', { noremap = true })

----------------------------------------------------------------------------
-- Args
----------------------------------------------------------------------------

-- Move between args easily
vim.api.nvim_set_keymap('n', 'sm', ':previous<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', 's,', ':next<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', 'sn', ':first<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', 's.', ':last<cr>', { noremap = true })

-- Add current buffer to the argument list
vim.api.nvim_set_keymap('n', 'saa', ':$argadd<cr>', { noremap = true })
-- Quickly add to arg list
vim.api.nvim_set_keymap('n', 'sad', ':argd<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', 'saD', ':%argd<cr>', { noremap = true })

--------------------------------------------------------------------------------
-- Buffers
--------------------------------------------------------------------------------

-- Move between buffers easily
vim.api.nvim_set_keymap('n', 'su', ':bprevious<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', 'si', ':bnext<cr>', { noremap = true })

-- Quickly delete buffer
vim.api.nvim_set_keymap('n', 'sd', ':bdelete<cr>', { noremap = true })
-- Delete unpinned buffers
vim.api.nvim_set_keymap('n', 'sD', [[bufdo if get(b:, 'aljendro_is_buffer_pinned', 0) == 0 \| exec 'bd' \| endif<cr>]],
  { noremap = true })

--------------------------------------------------------------------------------
-- Tabs
--------------------------------------------------------------------------------

-- Move between tabs easily
vim.api.nvim_set_keymap('n', 'sy', 'gT', { noremap = true })
vim.api.nvim_set_keymap('n', 'so', 'gt', { noremap = true })
-- Move a window into a new tabpage
vim.api.nvim_set_keymap('n', '<leader>tw', '<C-w>T', { noremap = true })
-- Move tabs around
vim.api.nvim_set_keymap('n', '<leader>tj', ':-1tabm<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>tk', ':+1tabm<cr>', { noremap = true })
-- Only keep current tab
vim.api.nvim_set_keymap('n', '<leader>to', ':tabo<cr>', { noremap = true })
-- Create a new tab at the end
vim.api.nvim_set_keymap('n', '<leader>tn', ':tabnew<cr>:tabmove<cr>', { noremap = true })
-- Create a new scratch buffer tab at the end
vim.api.nvim_set_keymap('n', '<leader>ts', [[:tabnew +setl\ buftype=nofile<cr>:tabmove<cr>]],
  { noremap = true })
-- Close the tab
vim.api.nvim_set_keymap('n', '<leader>tc', ':tabclose<cr>', { noremap = true })


----------------------------------------------------------------------------
-- Folds
----------------------------------------------------------------------------

-- Easier folds
vim.api.nvim_set_keymap('n', '<leader>fj', 'zrzz', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fk', 'zmzz', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fh', 'zMzz', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fl', 'zRzz', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fo', 'zozz', { noremap = true })
vim.api.nvim_set_keymap('x', '<leader>fo', 'zozz', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fO', 'zOzz', { noremap = true })
vim.api.nvim_set_keymap('x', '<leader>fO', 'zOzz', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fc', 'zczz', { noremap = true })
vim.api.nvim_set_keymap('x', '<leader>fc', 'zczz', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fC', 'zCzz', { noremap = true })
vim.api.nvim_set_keymap('x', '<leader>fC', 'zCzz', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fe', 'mazMzv`azczOzz', { noremap = true })
-- Reset Folds
vim.api.nvim_set_keymap('n', '<leader>fr', 'zx', { noremap = true })

----------------------------------------------------------------------------
-- Sessions
----------------------------------------------------------------------------

-- Quick Session
vim.api.nvim_set_keymap('n', '<leader>ss', [[:wall \| call v:lua.MakeSession(' . nr2char(getchar()) . ')<cr>']],
  { expr = true, noremap = true })
vim.api.nvim_set_keymap('n', '<leader>sr',
  [[:wall \| call v:lua.MakeSession("default") \| tabonly \| call v:lua.LoadSession(' . nr2char(getchar()) . ')<cr>']],
  { expr = true, noremap = true })
vim.api.nvim_set_keymap('n', '<leader>sd', [[:wall \| call v:lua.LoadSession('default')<cr>]],
  { noremap = true })

----------------------------------------------------------------------------
-- Profiling
----------------------------------------------------------------------------

-- Profile everything
vim.api.nvim_set_keymap('n', '<leader>pp',
  [[:profile start profile-all.local.txt \| profile file * \| profile func *<cr>]], { noremap = true })

----------------------------------------------------------------------------
-- Macros
----------------------------------------------------------------------------

-- Easier macro execution
vim.api.nvim_set_keymap('n', '<leader>m', ':call v:lua.RecordMacro()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'Q', '@@', { noremap = true })
vim.api.nvim_set_keymap('x', 'Q', ':norm! @@<cr>', { noremap = true })

vim.api.nvim_set_keymap('n', '<leader>an', ':call v:lua.AppendNewlineToRegister()<cr>',
  { noremap = true, silent = true })

--------------------------------------------------------------------------------
-- Miscellaneous
--------------------------------------------------------------------------------

-- Go onto folded lines
vim.api.nvim_set_keymap('n', 'j', 'gj', { noremap = true })
vim.api.nvim_set_keymap('n', 'k', 'gk', { noremap = true })

-- Undo breakpoints
vim.api.nvim_set_keymap('i', ',', ',<C-g>u', { noremap = true })
vim.api.nvim_set_keymap('i', '.', '.<C-g>u', { noremap = true })
vim.api.nvim_set_keymap('i', '!', '!<C-g>u', { noremap = true })
vim.api.nvim_set_keymap('i', '?', '?<C-g>u', { noremap = true })

-- Keep cursor in same place
vim.api.nvim_set_keymap('n', 'J', 'mzJ`z', { noremap = true })

-- Close highlighting
vim.api.nvim_set_keymap('n', '<leader><enter>', ':noh<cr>', { noremap = true })

-- Better tabbing alignment
vim.api.nvim_set_keymap('x', '<', '<gv', { noremap = true })
vim.api.nvim_set_keymap('x', '>', '>gv', { noremap = true })

-- Next character remap
vim.api.nvim_set_keymap('n', '<leader>;', ';', { noremap = true })
vim.api.nvim_set_keymap('x', '<leader>;', ';', { noremap = true })

-- Use the . to execute once for each line of a visual selection
vim.api.nvim_set_keymap('x', '.', ':normal .<cr>', { noremap = true })

-- Faster shifting
vim.api.nvim_set_keymap('n', '<Left>', 'zH', { noremap = true })
vim.api.nvim_set_keymap('n', '<Right>', 'zL', { noremap = true })

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

filetype plugin indent on
colorscheme tokyonight
match errorMsg /\s\+$/


" Code signature
iabbrev @@ Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
" Quick Grep and Location/Quickfix List opens
cnoreabbrev <expr> grep v:lua.CommandAbbreviation('grep', "silent grep  \| copen<left><left><left><left><left><left><left><left>")
cnoreabbrev <expr> lgrep v:lua.CommandAbbreviation('lgrep', "silent lgrep  <C-r>=expand('%:p')<cr> \| lopen<C-b><right><right><right><right><right><right><right><right><right><right><right><right><right>")
noreabbrev --ml --multiline
noreabbrev --mla --multiline --multiline-dotall
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
