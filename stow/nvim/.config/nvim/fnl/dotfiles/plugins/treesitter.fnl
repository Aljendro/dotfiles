(module dotfiles.plugins.treesitter
  {autoload {treesitter nvim-treesitter.configs}})

(let [(ok? treesitter) (pcall require "nvim-treesitter.configs")]
  (when ok?
    (treesitter.setup
      {:ensure_installed ["bash"
                          "c"
                          "clojure"
                          "comment"
                          "cpp"
                          "css"
                          "diff"
                          "dockerfile"
                          "fennel"
                          "git_rebase"
                          "gitattributes"
                          "gitignore"
                          "go"
                          "gomod"
                          "gowork"
                          "graphql"
                          "help"
                          "html"
                          "javascript"
                          "jsdoc"
                          "json"
                          "jsonc"
                          "lua"
                          "make"
                          "markdown"
                          "pug"
                          "python"
                          "query"
                          "regex"
                          "rust"
                          "scss"
                          "sql"
                          "toml"
                          "tsx"
                          "typescript"
                          "vim"
                          "yaml"]

       :indent {:enable true}
       :highlight {:enable true
                   :additional_vim_regex_highlighting false}
       :incremental_selection {:enable true
                               :keymaps {:init_selection "<leader>y"
                                         :node_decremental "<leader>u"
                                         :node_incremental "<leader>i"}}})))

