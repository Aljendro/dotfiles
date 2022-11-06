(module dotfiles.plugins.surround
  {autoload {{: kmap} dotfiles.core.common}})

(kmap :n "<leader>'" "ysiw'" {:noremap false})
(kmap :n "<leader>\"" "ysiw\"" {:noremap false})
(kmap :n "<leader>`" "ysiw`" {:noremap false})
(kmap :n "<leader>)" "ysiw)" {:noremap false})
(kmap :n "<leader>}" "ysiw}" {:noremap false})
(kmap :n "<leader>]" "ysiw]" {:noremap false})

