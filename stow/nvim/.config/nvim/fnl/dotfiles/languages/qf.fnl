(module dotfiles.languages.markdown
  {autoload {{: kbmap : current-buf} dotfiles.core.common}})

;; Do not lose focus of quickfix when pressing enter
(kbmap current-buf :n "<cr>" "<CR><C-w>p" {:silent true})
;; Deleting a line immediately saves the buffer
(kbmap current-buf :n "dd" "dd:w<cr>" {:silent true})

