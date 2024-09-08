-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

------------------------------------------------------------------------------------------------------------------------
-- Abbreviations
------------------------------------------------------------------------------------------------------------------------

-- Code signature
vim.cmd("inoreabbrev @@ Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>")
-- Quick Grep and Location/Quickfix List opens
vim.cmd(
  "cnoreabbrev <expr> grep v:lua.CommandAbbreviation('grep', \"silent grep  \\| copen<left><left><left><left><left><left><left><left>\")"
)
vim.cmd(
  "cnoreabbrev <expr> lgrep v:lua.CommandAbbreviation('lgrep', \"silent lgrep  <C-r>=expand('%:p')<cr> \\| lopen<C-b><right><right><right><right><right><right><right><right><right><right><right><right><right>\")"
)
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

map(
  "n",
  "<leader>um",
  ":setlocal modifiable! readonly!<cr>:setlocal modifiable? readonly?<cr>",
  { desc = "Modifiable and Readonly" }
)
map(
  "n",
  "<leader>up",
  ":call v:lua.BToggle('aljendro_is_buffer_pinned', 'Buffer pinned: ')<cr>",
  { desc = "Buffer Pin" }
)
map(
  "n",
  "<leader>uP",
  "mZ:bufdo call v:lua.ToggleOff('aljendro_is_buffer_pinned', 'Buffer pinned: ')<cr>`Z",
  { desc = "Buffer All Off" }
)
map("n", "<leader>ut", ":call v:lua.TToggle('aljendro_is_tab_pinned', 'Tab pinned: ')<cr>", { desc = "Tab Pin" })
LazyVim.toggle.map("<leader>ua", LazyVim.toggle("cursorcolumn", { name = "Cursor Column" }))
LazyVim.toggle.map("<leader>ufe", LazyVim.toggle("foldenable", { name = "Folds" }))
LazyVim.toggle.map("<leader>ul", LazyVim.toggle("lazyredraw", { name = "Lazy Redraw" }))
LazyVim.toggle.map("<leader>uff", LazyVim.toggle.format())
LazyVim.toggle.map("<leader>us", LazyVim.toggle("spell", { name = "Spelling" }))
LazyVim.toggle.map("<leader>uw", LazyVim.toggle("wrap", { name = "Wrap" }))
LazyVim.toggle.map("<leader>uW", LazyVim.toggle("wrapscan", { name = "Wrap Scan" }))
LazyVim.toggle.map("<leader>uL", LazyVim.toggle("relativenumber", { name = "Relative Number" }))
LazyVim.toggle.map("<leader>ud", LazyVim.toggle.diagnostics)
LazyVim.toggle.map("<leader>un", LazyVim.toggle.number)
LazyVim.toggle.map(
  "<leader>uc",
  LazyVim.toggle("conceallevel", { values = { 0, vim.o.conceallevel > 0 and vim.o.conceallevel or 2 } })
)
LazyVim.toggle.map("<leader>uy", LazyVim.toggle.treesitter)
LazyVim.toggle.map("<leader>ub", LazyVim.toggle("background", { values = { "light", "dark" }, name = "Background" }))
if vim.lsp.inlay_hint then
  LazyVim.toggle.map("<leader>uh", LazyVim.toggle.inlay_hints)
end

------------------------------------------------------------------------------------------------------------------------
-- Quickfix
------------------------------------------------------------------------------------------------------------------------

-- Move between quickfix list easily
map("n", "<M-h>", ":cNfile<cr>zz", { silent = true })
map("n", "<M-j>", ":cnext<cr>zz", { silent = true })
map("n", "<M-k>", ":cprevious<cr>zz", { silent = true })
map("n", "<M-l>", ":cnfile<cr>zz", { silent = true })

-- Move between location list easily
map("n", "<M-m>", ":lnext<cr>zz", { silent = true })
map("n", "<M-,>", ":lprevious<cr>zz", { silent = true })

vim.cmd("cnoreabbrev <expr> qnf v:lua.CommandAbbreviation('qnf', 'cfdo set nofoldenable')")

------------------------------------------------------------------------------------------------------------------------
-- Splits/Windows
------------------------------------------------------------------------------------------------------------------------

-- Tab split
map("n", "st", ":tab split<cr>", { desc = "Tab Split" })

-- Vertical split
map("n", "sv", "<C-w>v", { desc = "Vertical Split" })

-- Horizontal split
map("n", "ss", "<C-w>s", { desc = "Horizontal Split" })

-- Close split
map("n", "sc", "<C-w>c", { desc = "Close Split" })

-- Move between windows easily
map("n", "sk", "<C-w><C-k>", { desc = "Move Up" })
map("n", "sj", "<C-w><C-j>", { desc = "Move Down" })
map("n", "sl", "<C-w><C-l>", { desc = "Move Right" })
map("n", "sh", "<C-w><C-h>", { desc = "Move Left" })

-- Move windows easily
map("n", "<C-w>j", "<C-w>J", { desc = "Move Window Down" })
map("n", "<C-w>k", "<C-w>K", { desc = "Move Window Up" })
map("n", "<C-w>l", "<C-w>L", { desc = "Move Window Right" })
map("n", "<C-w>h", "<C-w>H", { desc = "Move Window Left" })

-- Resize windows
map("n", "<M-d>", ":resize -4<cr>", { desc = "Resize Down" })
map("n", "<M-e>", ":resize +4<cr>", { desc = "Resize Up" })
map("n", "<M-s>", ":vertical resize +8<cr>", { desc = "Resize Right" })
map("n", "<M-f>", ":vertical resize -8<cr>", { desc = "Resize Left" })

------------------------------------------------------------------------------------------------------------------------
-- Search
------------------------------------------------------------------------------------------------------------------------

-- Center when jumping
map("n", "<C-o>", "<C-o>zz")
map("n", "<C-i>", "<C-i>zz")

-- Easier search and/or replace
map("n", "<leader>/r", ":%s//gci<Left><Left><Left><Left>", { desc = "Search/Replace (default)" })
-- Count the number of possible replacements (occurrences and lines)
map("n", "<leader>/c", ":%s///gn<cr>", { desc = "Search Count" })

-- Change word under cursor giving the ability to reapply with .
map("x", "<leader>/w", "*Ncgn", { desc = "Change Word" })
map("n", "<leader>/w", "g*cgn", { desc = "Change Word" })

-- Visual mode pressing * or # searches for the current selection
map("x", "*", "mi:call v:lua.GetSelectedText()<cr>/<C-R>=@/<cr><cr>`i")
map("x", "#", "mi:call v:lua.GetSelectedText()<cr>?<C-R>=@/<cr><cr>`i")

-- Maintain position when you hit * or #
map("n", "*", ":keepjumps normal! mi*`i<cr>")
map("n", "g*", ":keepjumps normal! mig*`i<cr>")
map("n", "#", ":keepjumps normal! mi#`i<cr>")
map("n", "g#", ":keepjumps normal! mig#`i<cr>")

-- Center cursor when searching
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
-- Close highlighting
map("n", "<leader><enter>", ":noh<cr>", { desc = "Clear Highlighting" })

------------------------------------------------------------------------------------------------------------------------
-- Args
------------------------------------------------------------------------------------------------------------------------

-- Move between args easily
map("n", "sm", ":previous<cr>", { desc = "Previous Arg" })
map("n", "s,", ":next<cr>", { desc = "Next Arg" })

-- Add current buffer to the argument list
map("n", "saa", ":$argadd<cr>", { desc = "Add Buffer to Arg List" })
-- Quickly add to arg list
map("n", "sad", ":argd<cr>", { desc = "Delete Buffer from Arg List" })
map("n", "saD", ":%argd<cr>", { desc = "Delete All Buffers from Arg List" })

------------------------------------------------------------------------------------------------------------------------
-- Buffers
------------------------------------------------------------------------------------------------------------------------

-- -- Move between buffers easily
map("n", "su", ":bprevious<cr>", { desc = "Previous Buffer" })
map("n", "si", ":bnext<cr>", { desc = "Next Buffer" })

-- Quickly delete buffer
map("n", "sd", ":bdelete<cr>", { desc = "Delete Buffer" })
-- Delete unpinned buffers
map(
  "n",
  "sD",
  ":bufdo if get(b:, \"aljendro_is_buffer_pinned\") == 0 | exec 'bd' | endif<cr>",
  { desc = "Delete Unpinned Buffers" }
)

-- Faster shifting
map("n", "<Left>", "zH")
map("n", "<Right>", "zL")

------------------------------------------------------------------------------------------------------------------------
-- Tabs
------------------------------------------------------------------------------------------------------------------------

-- Move between tabs easily
map("n", "sy", "gT", { desc = "Previous Tab" })
map("n", "so", "gt", { desc = "Next Tab" })
-- Move a window into a new tabpage
map("n", "<leader>!", "<C-w>T", { desc = "Move Window to New Tab" })
-- Move tabs around
map("n", "s<C-h>", ":-1tabm<cr>", { desc = "Move Tab Left" })
map("n", "s<C-l>", ":+1tabm<cr>", { desc = "Move Tab Right" })
-- Create a new tab at the end
map("n", "sn", ":tabnew<cr>:tabmove<cr>", { desc = "New Tab" })
-- Create a new scratch buffer tab at the end
map("n", "sN", ":tabnew +setl\\ buftype=nofile<cr>:tabmove<cr>", { desc = "New Scratch Tab" })
-- Close the tab
map("n", "ste", ":tabclose<cr>", { desc = "Close Tab" })
-- Delete unpinned tabs
map(
  "n",
  "stD",
  ":tabdo if get(t:, \"aljendro_is_tab_pinned\") == 0 | exec 'tabclose' | endif<cr>",
  { desc = "Delete Unpinned Tabs" }
)

------------------------------------------------------------------------------------------------------------------------
-- Macros
------------------------------------------------------------------------------------------------------------------------

-- Easier macro execution
map("n", "<leader><leader>m", ":call v:lua.RecordMacro()<cr>", { silent = true, desc = "Record Macro" })
map("n", "Q", "@@", { desc = "Execute Macro" })
map("x", "Q", ":norm! @@<cr>", { desc = "Execute Macro" })

map(
  "n",
  "<leader>an",
  ":call v:lua.AppendNewlineToRegister()<cr>",
  { silent = true, desc = "Append Newline to Register" }
)

------------------------------------------------------------------------------------------------------------------------
-- Miscellaneous
------------------------------------------------------------------------------------------------------------------------

-- Keep cursor in same place
map("n", "J", "mzJ`z")

-- Next character remap
map("n", "<leader>;", ";")
map("x", "<leader>;", ";")

-- Use the . to execute once for each line of a visual selection
map("x", ".", ":normal .<cr>")
