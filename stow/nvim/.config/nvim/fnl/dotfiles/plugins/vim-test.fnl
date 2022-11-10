(module dotfiles.plugins.vim-test
  {autoload {{: kmap} dotfiles.core.common}})

(tset vim.g "test#strategy" "vimux")

(kmap :n "<leader>tt" ":TestNearest<cr>")
(kmap :n "<leader>tf" ":TestFile<cr>")
(kmap :n "<leader>ta" ":TestSuite<cr>")
(kmap :n "<leader>tl" ":TestLast<cr>")
(kmap :n "<leader>tv" ":TestVisit<cr>")

