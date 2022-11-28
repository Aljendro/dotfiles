(module dotfiles.plugins.treesitter)

(let [(ok? treesitter) (pcall require "nvim-treesitter.configs")]
  (when ok?
    (treesitter.setup
      {:ensure_installed ["bash" "c" "clojure" "comment" "commonlisp" "cpp" "css" "diff"
                          "dockerfile" "fennel" "git_rebase" "gitattributes" "gitignore" "go" "gomod"
                          "gowork" "graphql" "help" "html" "http" "javascript" "jsdoc" "json" "json5"
                          "jsonc" "lua" "make" "markdown" "markdown_inline" "norg" "pug" "python" "query"
                          "regex" "rust" "scss" "sql" "todotxt" "toml" "tsx" "typescript" "vim" "yaml"]
       :indent {:enable true}
       :highlight {:enable true
                   :additional_vim_regex_highlighting false}
       :incremental_selection {:enable true
                               :keymaps {:init_selection "<leader>y"
                                         :node_decremental "<leader>u"
                                         :node_incremental "<leader>i"}}
       :playground {:enable true
                    :disable {}
                    :updatetime 25
                    :persist_queries false
                    :keybindings {:toggle_query_editor "o"
                                  :toggle_hl_groups "i"
                                  :toggle_injected_languages "t"
                                  :toggle_anonymous_nodes "a"
                                  :toggle_language_display "I"
                                  :focus_language "f"
                                  :unfocus_language "F"
                                  :update "R"
                                  :goto_node "<cr>"
                                  :show_help "?"}}})))

