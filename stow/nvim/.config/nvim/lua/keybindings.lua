local c = require("common")

-- Leader Keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Quick reload
c.kmap("n", "<leader>r", ":lua require('plenary.reload').reload_module('dotfiles', true)<cr>:source $MYVIMRC<cr>")

------------------------------------------------------------------------------------------------------------------------
-- Scrolling
------------------------------------------------------------------------------------------------------------------------

c.kmap("n", "<C-k>", "<C-u>")
c.kmap("n", "<C-j>", "<C-d>")
c.kmap("n", "<PageUp>", "<C-b>")
c.kmap("n", "<PageDown>", "<C-f>")
c.kmap("n", "<Up>", "5<C-y>")
c.kmap("n", "<Down>", "5<C-e>")
c.kmap("x", "<C-k>", "<C-u>")
c.kmap("x", "<C-j>", "<C-d>")
c.kmap("x", "<PageUp>", "<C-b>")
c.kmap("x", "<PageDown>", "<C-f>")
c.kmap("x", "<Up>", "5<C-y>")
c.kmap("x", "<Down>", "5<C-e>")

------------------------------------------------------------------------------------------------------------------------
-- Abbreviations
------------------------------------------------------------------------------------------------------------------------

-- Code signature
vim.cmd("iabbrev @@ Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>")
-- Quick Grep and Location/Quickfix List opens
vim.cmd(
    "cnoreabbrev <expr> grep v:lua.CommandAbbreviation('grep', \"silent grep  \\| copen<left><left><left><left><left><left><left><left>\")")
vim.cmd(
    "cnoreabbrev <expr> lgrep v:lua.CommandAbbreviation('lgrep', \"silent lgrep  <C-r>=expand('%:p')<cr> \\| lopen<C-b><right><right><right><right><right><right><right><right><right><right><right><right><right>\")")
vim.cmd("noreabbrev _ml -U")
vim.cmd("noreabbrev _mla -U --multiline-dotall")
vim.cmd("noreabbrev _r10 <left>.{0,10}?")
vim.cmd("noreabbrev _r20 <left>.{0,20}?")
vim.cmd("noreabbrev _r50 <left>.{0,50}?")
vim.cmd("noreabbrev _r100 <left>.{0,100}?")
-- Non Greedy *
vim.cmd("cnoreabbrev *? <left>\\{-}<C-r>=v:lua.EatChar('\\s')<cr>")
-- Always open help in new tab
vim.cmd("cnoreabbrev <expr> tah v:lua.CommandAbbreviation('tah', 'tab help') . ' '")
-- Change filetype
vim.cmd("cnoreabbrev <expr> ft v:lua.CommandAbbreviation('ft', 'set ft=')")
-- Diff files in window
vim.cmd("cnoreabbrev <expr> wdt v:lua.CommandAbbreviation('wdt', 'windo diffthis')")
-- Tabularize
vim.cmd("cnoreabbrev <expr> t v:lua.CommandAbbreviation('t', 'Tab /')")

------------------------------------------------------------------------------------------------------------------------
-- Options Toggles
------------------------------------------------------------------------------------------------------------------------

c.kmap("n", "<leader>oc", ":set cursorcolumn!<cr>:set cursorcolumn?<cr>")
c.kmap("n", "<leader>of", ":set foldenable!<cr>:set foldenable?<cr>")
c.kmap("n", "<leader>ol", ":set lazyredraw!<cr>:set lazyredraw?<cr>")
c.kmap("n", "<leader>on", ":set number!<cr>:set number?<cr>")
c.kmap("n", "<leader>om", ":setlocal modifiable! readonly!<cr>:setlocal modifiable? readonly?<cr>")
c.kmap("n", "<leader>or", ":set relativenumber!<cr>:set relativenumber?<cr>")
c.kmap("n", "<leader>ob", ":set scrollbind!<cr>:set scrollbind?<cr>")
c.kmap("n", "<leader>osc", ":set spell!<cr>:set spell?<cr>")
c.kmap("n", "<leader>oss", ":lua require('dotfiles.plugins.neoscroll').ToggleSmoothScroll()<cr>")
c.kmap("n", "<leader>oww", ":set wrap!<cr>:set wrap?<cr>")
c.kmap("n", "<leader>ows", ":set wrapscan!<cr>:set wrapscan?<cr>")
c.kmap("n", "<leader>op", ":call v:lua.Toggle('aljendro_is_buffer_pinned', 'Buffer pinned: ')<cr>")
c.kmap("n", "<leader>oP", "mZ:bufdo call v:lua.ToggleOff('aljendro_is_buffer_pinned', 'Buffer pinned: ')<cr>`Z")

------------------------------------------------------------------------------------------------------------------------
-- Saving
------------------------------------------------------------------------------------------------------------------------

-- Faster buffer delete quitting
c.kmap("n", "<leader>q", ":bd!<cr>")

------------------------------------------------------------------------------------------------------------------------
-- Quickfix
------------------------------------------------------------------------------------------------------------------------

-- Move between quickfix list easily
c.kmap("n", "<M-h>", ":cNfile<cr>zz")
c.kmap("n", "<M-j>", ":cnext<cr>zz")
c.kmap("n", "<M-k>", ":cprevious<cr>zz")
c.kmap("n", "<M-l>", ":cnfile<cr>zz")

-- Move between location list easily
c.kmap("n", "<M-m>", ":lnext<cr>zz")
c.kmap("n", "<M-,>", ":lprevious<cr>zz")

vim.cmd("cnoreabbrev <expr> qnf v:lua.CommandAbbreviation('qnf', 'cfdo set nofoldenable')")

------------------------------------------------------------------------------------------------------------------------
-- Splits/Windows
------------------------------------------------------------------------------------------------------------------------

-- Only split
c.kmap("n", "ss", "<C-w>o")

-- Tab split
c.kmap("n", "st", ":tab split<cr>")

-- Vertical split
c.kmap("n", "sv", "<C-w>v")

-- Close split
c.kmap("n", "sc", "<C-w>c")

-- Move between windows easily
c.kmap("n", "sk", "<C-w><C-k>")
c.kmap("n", "sj", "<C-w><C-j>")
c.kmap("n", "sl", "<C-w><C-l>")
c.kmap("n", "sh", "<C-w><C-h>")

-- Move windows easily
c.kmap("n", "<C-w>j", "<C-w>J")
c.kmap("n", "<C-w>k", "<C-w>K")
c.kmap("n", "<C-w>l", "<C-w>L")
c.kmap("n", "<C-w>h", "<C-w>H")

-- Resize windows
c.kmap("n", "<M-d>", ":resize -4<cr>")
c.kmap("n", "<M-e>", ":resize +4<cr>")
c.kmap("n", "<M-s>", ":vertical resize +8<cr>")
c.kmap("n", "<M-f>", ":vertical resize -8<cr>")

------------------------------------------------------------------------------------------------------------------------
-- Search
------------------------------------------------------------------------------------------------------------------------

-- Center when jumping
c.kmap("n", "<C-o>", "<C-o>zz")
c.kmap("n", "<C-i>", "<C-i>zz")

-- Easier search and/or replace
c.kmap("n", "<leader>/r", ":%s//gci<Left><Left><Left><Left>")
-- Count the number of possible replacements (occurrences and lines)
c.kmap("n", "<leader>/c", ":%s///gn<cr>")

-- Change word under cursor giving the ability to reapply with .
c.kmap("x", "<leader>/w", "*Ncgn", { noremap = false })
c.kmap("n", "<leader>/w", "g*cgn", { noremap = false })

-- Visual mode pressing * or # searches for the current selection
c.kmap("x", "*", "mi:call v:lua.GetSelectedText()<cr>/<C-R>=@/<cr><cr>`i")
c.kmap("x", "#", "mi:call v:lua.GetSelectedText()<cr>?<C-R>=@/<cr><cr>`i")

-- Maintain position when you hit * or #
c.kmap("n", "*", ":keepjumps normal! mi*`i<cr>")
c.kmap("n", "g*", ":keepjumps normal! mig*`i<cr>")
c.kmap("n", "#", ":keepjumps normal! mi#`i<cr>")
c.kmap("n", "g#", ":keepjumps normal! mig#`i<cr>")

-- Center cursor when searching
c.kmap("n", "n", "nzzzv")
c.kmap("n", "N", "Nzzzv")
-- Close highlighting
c.kmap("n", "<leader><enter>", ":noh<cr>")

------------------------------------------------------------------------------------------------------------------------
-- Args
------------------------------------------------------------------------------------------------------------------------

-- Move between args easily
c.kmap("n", "sm", ":previous<cr>")
c.kmap("n", "s,", ":next<cr>")
c.kmap("n", "sn", ":first<cr>")
c.kmap("n", "s.", ":last<cr>")

-- Add current buffer to the argument list
c.kmap("n", "saa", ":$argadd<cr>")
-- Quickly add to arg list
c.kmap("n", "sad", ":argd<cr>")
c.kmap("n", "saD", ":%argd<cr>")

------------------------------------------------------------------------------------------------------------------------
-- Buffers
------------------------------------------------------------------------------------------------------------------------

-- Move between buffers easily
c.kmap("n", "su", ":bprevious<cr>")
c.kmap("n", "si", ":bnext<cr>")

-- Quickly delete buffer
c.kmap("n", "sd", ":bdelete<cr>")
-- Delete unpinned buffers
c.kmap("n", "sD", ":bufdo if get(b:, \"aljendro_is_buffer_pinned\") == 0 | exec 'bd' | endif<cr>")

-- Faster shifting
c.kmap("n", "<Left>", "zH")
c.kmap("n", "<Right>", "zL")

------------------------------------------------------------------------------------------------------------------------
-- Tabs
------------------------------------------------------------------------------------------------------------------------

-- Move between tabs easily
c.kmap("n", "sy", "gT")
c.kmap("n", "so", "gt")
-- Move a window into a new tabpage
c.kmap("n", "<leader>tw", "<C-w>T")
-- Move tabs around
c.kmap("n", "<leader>tj", ":-1tabm<cr>")
c.kmap("n", "<leader>tk", ":+1tabm<cr>")
-- Only keep current tab
c.kmap("n", "<leader>to", ":tabo<cr>")
-- Create a new tab at the end
c.kmap("n", "<leader>tn", ":tabnew<cr>:tabmove<cr>")
-- Create a new scratch buffer tab at the end
c.kmap("n", "<leader>ts", ":tabnew +setl\\ buftype=nofile<cr>:tabmove<cr>")
-- Close the tab
c.kmap("n", "<leader>tc", ":tabclose<cr>")

------------------------------------------------------------------------------------------------------------------------
-- Folds
------------------------------------------------------------------------------------------------------------------------

-- Go onto folded lines
c.kmap("n", "j", "gj")
c.kmap("n", "k", "gk")

------------------------------------------------------------------------------------------------------------------------
-- Sessions
------------------------------------------------------------------------------------------------------------------------

-- Quick Session
c.kmap("n", "<leader>ss", "':wall | call v:lua.MakeSession(\"' . nr2char(getchar()) . '\")<cr>'", { expr = true })
c.kmap("n", "<leader>sr",
    "':wall | call v:lua.MakeSession(\"default\") | tabonly | call v:lua.LoadSession(\"' . nr2char(getchar()) . '\")<cr>'",
    { expr = true })
c.kmap("n", "<leader>sd", ":wall | call v:lua.LoadSession(\"default\")<cr>")

------------------------------------------------------------------------------------------------------------------------
-- Profiling
------------------------------------------------------------------------------------------------------------------------

-- Profile everything
c.kmap("n", "<leader>pp", ":profile start profile-all.local.txt | profile file * | profile func *<cr>")

------------------------------------------------------------------------------------------------------------------------
-- Macros
------------------------------------------------------------------------------------------------------------------------

-- Easier macro execution
c.kmap("n", "<leader>m", ":call v:lua.RecordMacro()<cr>", { silent = true })
c.kmap("n", "Q", "@@")
c.kmap("x", "Q", ":norm! @@<cr>")

c.kmap("n", "<leader>an", ":call v:lua.AppendNewlineToRegister()<cr>")

------------------------------------------------------------------------------------------------------------------------
-- Terminal
------------------------------------------------------------------------------------------------------------------------

c.kmap("t", "<c-\\><c-\\>", "<c-\\><c-n>")

------------------------------------------------------------------------------------------------------------------------
-- Miscellaneous
------------------------------------------------------------------------------------------------------------------------

-- Undo breakpoints
c.kmap("i", ",", ",<C-g>u")
c.kmap("i", ".", ".<C-g>u")
c.kmap("i", "!", "!<C-g>u")
c.kmap("i", "?", "?<C-g>u")

-- Keep cursor in same place
c.kmap("n", "J", "mzJ`z")

-- Better tabbing alignment
c.kmap("x", "<", "<gv")
c.kmap("x", ">", ">gv")

-- Next character remap
c.kmap("n", "<leader>;", ";")
c.kmap("x", "<leader>;", ";")

-- Use the . to execute once for each line of a visual selection
c.kmap("x", ".", ":normal .<cr>")
