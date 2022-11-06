(module dotfiles.languages.rust)

(defn setup []
  (set vim.opt_local.shiftwidth 4)
  (set vim.opt_local.softtabstop 4)
  (set vim.opt_local.tabstop 4))

