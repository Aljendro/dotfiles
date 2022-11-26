(module dotfiles.languages.markdown
  {autoload {{: kbmap : current-buf} dotfiles.core.common}})

(defn setup []
  (set vim.opt_local.foldmethod "expr")
  (set vim.opt_local.foldexpr "nvim_treesitter#foldexpr()")

  ;; Reflow bases on column length
  (kbmap current-buf :n "<leader>fm" "vapgq" {:silent true})

  (kbmap current-buf :n "<C-f>" ":MarkdownPreviewToggle<cr>" {:silent true})

  (kbmap current-buf :n "<leader><leader>c" ":lua ToggleListItem('✅')<cr>" {:silent true})
  (kbmap current-buf :n "<leader><leader>t" ":lua ToggleListItem('👍')<cr>" {:silent true})
  (kbmap current-buf :n "<leader><leader>p" ":lua ToggleListItem('🚧')<cr>" {:silent true})
  (kbmap current-buf :n "<leader><leader>r" ":lua ToggleListItem('🚀')<cr>" {:silent true})
  (kbmap current-buf :n "<leader><leader>f" ":lua ToggleListItem('🔥')<cr>" {:silent true}))

