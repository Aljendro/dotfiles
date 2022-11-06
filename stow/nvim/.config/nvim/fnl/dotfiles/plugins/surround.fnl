(module dotfiles.plugins.surround
  {autoload {{: kmap} dotfiles.core.common}})

(kmap :n "<leader>'" "ysiw'" {:silent true})
(kmap :n "<leader>\"" "ysiw\"" {:silent true})
(kmap :n "<leader>`" "ysiw`" {:silent true})
(kmap :n "<leader>)" "ysiw)" {:silent true})
(kmap :n "<leader>}" "ysiw}" {:silent true})

