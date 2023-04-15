(module dotfiles.core.keybindings
  {require {{: kmap} dotfiles.core.common}})

;; Leader Keys
(kmap :n "<space>" "<nop>")
(kmap :n "<Bslash>" "<nop>")
(set vim.g.mapleader " ")
(set vim.g.maplocalleader "\\")

;; Quick reload
(kmap :n "<leader>r" ":lua require('plenary.reload').reload_module('dotfiles', true)<cr>:source $MYVIMRC<cr>")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Abbreviations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Code signature
(vim.cmd "iabbrev @@ Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>")
;; Quick Grep and Location/Quickfix List opens
(vim.cmd "cnoreabbrev <expr> grep v:lua.CommandAbbreviation('grep', \"silent grep  \\| copen<left><left><left><left><left><left><left><left>\")")
(vim.cmd "cnoreabbrev <expr> lgrep v:lua.CommandAbbreviation('lgrep', \"silent lgrep  <C-r>=expand('%:p')<cr> \\| lopen<C-b><right><right><right><right><right><right><right><right><right><right><right><right><right>\")")
(vim.cmd "noreabbrev _ml --multiline")
(vim.cmd "noreabbrev _mla --multiline --multiline-dotall")
;; Non Greedy *
(vim.cmd "cnoreabbrev *? <left>\\{-}<C-r>=v:lua.EatChar('\\s')<cr>")
;; Always open help in new tab
(vim.cmd "cnoreabbrev <expr> tah v:lua.CommandAbbreviation('tah', 'tab help') . ' '")
;; Change filetype
(vim.cmd "cnoreabbrev <expr> ft v:lua.CommandAbbreviation('ft', 'set ft=')")
;; Diff files in window
(vim.cmd "cnoreabbrev <expr> wdt v:lua.CommandAbbreviation('wdt', 'windo diffthis')")
;; Tabularize
(vim.cmd "cnoreabbrev <expr> t v:lua.CommandAbbreviation('t', 'Tab /')")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Options Toggles
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(kmap :n "<leader>oc" ":set cursorcolumn!<cr>:set cursorcolumn?<cr>")
(kmap :n "<leader>of" ":set foldenable!<cr>:set foldenable?<cr>")
(kmap :n "<leader>ol" ":set lazyredraw!<cr>:set lazyredraw?<cr>")
(kmap :n "<leader>on" ":set number!<cr>:set number?<cr>")
(kmap :n "<leader>om" ":setlocal modifiable! readonly!<cr>:setlocal modifiable? readonly?<cr>")
(kmap :n "<leader>or" ":set relativenumber!<cr>:set relativenumber?<cr>")
(kmap :n "<leader>ob" ":set scrollbind!<cr>:set scrollbind?<cr>")
(kmap :n "<leader>osc" ":set spell!<cr>:set spell?<cr>")
(kmap :n "<leader>oss" ":lua require('dotfiles.plugins.neoscroll').ToggleSmoothScroll()<cr>")
(kmap :n "<leader>oww" ":set wrap!<cr>:set wrap?<cr>")
(kmap :n "<leader>ows" ":set wrapscan!<cr>:set wrapscan?<cr>")
(kmap :n "<leader>op" ":call v:lua.Toggle('aljendro_is_buffer_pinned', 'Buffer pinned: ')<cr>")
(kmap :n "<leader>oP" "mZ:bufdo call v:lua.ToggleOff('aljendro_is_buffer_pinned', 'Buffer pinned: ')<cr>`Z")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Saving
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Faster buffer delete quitting
(kmap :n "<leader>q" ":bd!<cr>")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Quickfix
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Move between quickfix list easily
(kmap :n "<M-h>" ":cNfile<cr>zz")
(kmap :n "<M-j>" ":cnext<cr>zz")
(kmap :n "<M-k>" ":cprevious<cr>zz")
(kmap :n "<M-l>" ":cnfile<cr>zz")

;; Move between location list easily
(kmap :n "<M-m>" ":lnext<cr>zz")
(kmap :n "<M-,>" ":lprevious<cr>zz")

(vim.cmd "cnoreabbrev <expr> qnf v:lua.CommandAbbreviation('qnf', 'cfdo set nofoldenable')")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Splits/Windows
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Only split
(kmap :n "ss" "<C-w>o")

;; Tab split
(kmap :n "st" ":tab split<cr>")

;; Vertical split
(kmap :n "sv" "<C-w>v")

;; Close split
(kmap :n "sc" "<C-w>c")

;; Move between windows easily
(kmap :n "sk" "<C-w><C-k>")
(kmap :n "sj" "<C-w><C-j>")
(kmap :n "sl" "<C-w><C-l>")
(kmap :n "sh" "<C-w><C-h>")

;; Move windows easily
(kmap :n "<C-w>j" "<C-w>J")
(kmap :n "<C-w>k" "<C-w>K")
(kmap :n "<C-w>l" "<C-w>L")
(kmap :n "<C-w>h" "<C-w>H")

;; Resize windows
(kmap :n "<M-d>" ":resize -4<cr>")
(kmap :n "<M-e>" ":resize +4<cr>")
(kmap :n "<M-s>" ":vertical resize +16<cr>")
(kmap :n "<M-f>" ":vertical resize -16<cr>")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Search
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Center when jumping
(kmap :n "<C-o>" "<C-o>zz")
(kmap :n "<C-i>" "<C-i>zz")

;; Easier search and/or replace
(kmap :n "<leader>/r" ":%s//gci<Left><Left><Left><Left>")
;; Count the number of possible replacements (occurrences and lines)
(kmap :n "<leader>/c" ":%s///gn<cr>")

;; Change word under cursor giving the ability to reapply with .
(kmap :x "<leader>/w" "*Ncgn" {:noremap false})
(kmap :n "<leader>/w" "g*cgn" {:noremap false})

;; Visual mode pressing * or # searches for the current selection
(kmap :x "*" "mi:call v:lua.GetSelectedText()<cr>/<C-R>=@/<cr><cr>`i")
(kmap :x "#" "mi:call v:lua.GetSelectedText()<cr>?<C-R>=@/<cr><cr>`i")

;; Maintain position when you hit * or #
(kmap :n "*" ":keepjumps normal! mi*`i<cr>")
(kmap :n "g*" ":keepjumps normal! mig*`i<cr>")
(kmap :n "#" ":keepjumps normal! mi#`i<cr>")
(kmap :n "g#" ":keepjumps normal! mig#`i<cr>")

;; Center cursor when searching
(kmap :n "n" "nzzzv")
(kmap :n "N" "Nzzzv")
;; Close highlighting
(kmap :n "<leader><enter>" ":noh<cr>")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Args
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Move between args easily
(kmap :n "sm" ":previous<cr>")
(kmap :n "s," ":next<cr>")
(kmap :n "sn" ":first<cr>")
(kmap :n "s." ":last<cr>")

;; Add current buffer to the argument list
(kmap :n "saa" ":$argadd<cr>")
;; Quickly add to arg list
(kmap :n "sad" ":argd<cr>")
(kmap :n "saD" ":%argd<cr>")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Buffers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Move between buffers easily
(kmap :n "su" ":bprevious<cr>")
(kmap :n "si" ":bnext<cr>")

;; Quickly delete buffer
(kmap :n "sd" ":bdelete<cr>")
;; Delete unpinned buffers
(kmap :n "sD" ":bufdo if get(b:, \"aljendro_is_buffer_pinned\") == 0 | exec 'bd' | endif<cr>")

;; Faster shifting
(kmap :n "<Left>" "zH")
(kmap :n "<Right>" "zL")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tabs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Move between tabs easily
(kmap :n "sy" "gT")
(kmap :n "so" "gt")
;; Move a window into a new tabpage
(kmap :n "<leader>tw" "<C-w>T")
;; Move tabs around
(kmap :n "<leader>tj" ":-1tabm<cr>")
(kmap :n "<leader>tk" ":+1tabm<cr>")
;; Only keep current tab
(kmap :n "<leader>to" ":tabo<cr>")
;; Create a new tab at the end
(kmap :n "<leader>tn" ":tabnew<cr>:tabmove<cr>")
;; Create a new scratch buffer tab at the end
(kmap :n "<leader>ts" ":tabnew +setl\\ buftype=nofile<cr>:tabmove<cr>")
;; Close the tab
(kmap :n "<leader>tc" ":tabclose<cr>")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Folds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Easier folds
(kmap :n "<leader>fj" "zrzz")
(kmap :n "<leader>fk" "zmzz")
(kmap :n "<leader>fh" "zMzz")
(kmap :n "<leader>fl" "zRzz")
(kmap :n "<leader>fo" "zozz")
(kmap :x "<leader>fo" "zozz")
(kmap :n "<leader>fO" "zOzz")
(kmap :x "<leader>fO" "zOzz")
(kmap :n "<leader>fc" "zczz")
(kmap :x "<leader>fc" "zczz")
(kmap :n "<leader>fC" "zCzz")
(kmap :x "<leader>fC" "zCzz")
(kmap :n "<leader>fe" "mazMzv`azczOzz")
;; Reset Folds
(kmap :n "<leader>fr" "zx")
;; Go onto folded lines
(kmap :n "j" "gj")
(kmap :n "k" "gk")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Sessions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Quick Session
(kmap :n "<leader>ss" "':wall | call v:lua.MakeSession(\"' . nr2char(getchar()) . '\")<cr>'" {:expr true})
(kmap :n "<leader>sr" "':wall | call v:lua.MakeSession(\"default\") | tabonly | call v:lua.LoadSession(\"' . nr2char(getchar()) . '\")<cr>'" {:expr true})
(kmap :n "<leader>sd" ":wall | call v:lua.LoadSession(\"default\")<cr>")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Profiling
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Profile everything
(kmap :n "<leader>pp" ":profile start profile-all.local.txt | profile file * | profile func *<cr>")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Easier macro execution
(kmap :n "<leader>m" ":call v:lua.RecordMacro()<cr>" {:silent true})
(kmap :n "Q" "@@")
(kmap :x "Q" ":norm! @@<cr>")

(kmap :n "<leader>an" ":call v:lua.AppendNewlineToRegister()<cr>")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Terminal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(kmap :t "<leader><esc>" "<c-\\><c-n>")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Miscellaneous
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Undo breakpoints
(kmap :i "," ",<C-g>u")
(kmap :i "." ".<C-g>u")
(kmap :i "!" "!<C-g>u")
(kmap :i "?" "?<C-g>u")

;; Keep cursor in same place
(kmap :n "J" "mzJ`z")

;; Better tabbing alignment
(kmap :x "<" "<gv")
(kmap :x ">" ">gv")

;; Next character remap
(kmap :n "<leader>;" ";")
(kmap :x "<leader>;" ";")

;; Use the . to execute once for each line of a visual selection
(kmap :x "." ":normal .<cr>")

