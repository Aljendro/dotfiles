(module dotfiles.plugins.tokyonight)

(let [(ok? tokyonight) (pcall require "tokyonight")]
  (when ok?
    (tokyonight.setup {:dim_inactive true})
    (vim.cmd "filetype plugin indent on")
    (vim.cmd "colorscheme tokyonight")
    (vim.cmd "match errorMsg /\\s\\+$/")
    (vim.cmd "highlight WinSeparator guifg=#999999")
    (vim.cmd "highlight LspReference guifg=NONE guibg=#665c54 guisp=NONE gui=NONE cterm=NONE ctermfg=NONE ctermbg=59")
    (vim.cmd "highlight! link LspReferenceText LspReference")
    (vim.cmd "highlight! link LspReferenceRead LspReference")
    (vim.cmd "highlight! link LspReferenceWrite LspReference")))

