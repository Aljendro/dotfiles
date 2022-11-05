(module dotfiles.plugins.treesitter
  {autoload {treesitter nvim-treesitter.configs}})

(treesitter.setup
  {:ensure_installed "all"
   :indent {:enable true}
   :highlight {:enable true
               :additional_vim_regex_highlighting false}
   :incremental_selection {:enable true
                           :keymaps {:init_selection "<leader>y"
                                     :node_decremental "<leader>u"
                                     :node_incremental "<leader>i"}}})


