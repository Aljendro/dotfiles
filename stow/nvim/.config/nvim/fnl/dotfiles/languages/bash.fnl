(module dotfiles.languages.bash)

(defn setup []
  (set vim.opt_local.smarttab true)
  (set vim.opt_local.smartindent false)
  (set vim.opt_local.expandtab false)

  (set vim.opt_local.shiftwidth 4)
  (set vim.opt_local.softtabstop 4)
  (set vim.opt_local.tabstop 4))

