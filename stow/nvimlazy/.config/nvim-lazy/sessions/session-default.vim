let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/dotfiles
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +2 ~/dotfiles/stow/nvimlazy/.config/nvim/lua/config/autocmds.lua
badd +50 stow/nvimlazy/.config/nvim/lua/config/keymaps.lua
badd +23 ~/dotfiles/stow/nvim/.config/nvim/lua/settings.lua
badd +7 ~/dotfiles/stow/nvimlazy/.config/nvim/lua/config/options.lua
badd +116 ~/dotfiles/stow/nvim/.config/nvim/lua/keybindings.lua
badd +1 ~/dotfiles/stow/nvimlazy/.config/nvim/init.lua
badd +20 ~/dotfiles/stow/nvimlazy/.config/nvim/lua/config/lazy.lua
badd +1 ~/dotfiles/stow/nvimlazy/.config/nvim/lazy-lock.json
badd +1 ~/dotfiles/stow/nvimlazy/.config/nvim/.gitignore
badd +1 ~/dotfiles/stow/nvimlazy/.config/nvim/.neoconf.json
argglobal
%argdel
edit stow/nvimlazy/.config/nvim/lua/config/keymaps.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 40 + 119) / 239)
exe 'vert 2resize ' . ((&columns * 198 + 119) / 239)
argglobal
enew
file NvimTree_1
balt ~/dotfiles/stow/nvim/.config/nvim/lua/keybindings.lua
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal nofen
wincmd w
argglobal
balt ~/dotfiles/stow/nvim/.config/nvim/lua/settings.lua
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 18 - ((17 * winheight(0) + 28) / 56)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 18
normal! 012|
wincmd w
2wincmd w
exe 'vert 1resize ' . ((&columns * 40 + 119) / 239)
exe 'vert 2resize ' . ((&columns * 198 + 119) / 239)
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
