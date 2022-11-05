(module dotfiles.plugins.nrrwrgn
  {autoload {{: kmap} dotfiles.core.common}})

(set vim.g.nrrw_rgn_vert true)
(set vim.g.nrrw_rgn_resize_window "relative")

(kmap :x "<leader>z" "<Plug>NrrwrgnDo" {:silent true})

