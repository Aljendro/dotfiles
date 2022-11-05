(module dotfiles.plugins.tokyonight
  {autoload {: tokyonight}})

(tokyonight.setup {:dim_inactive true})
(vim.cmd "filetype plugin indent on")
(vim.cmd "colorscheme tokyonight")
(vim.cmd "match errorMsg /\\s\\+$/")

