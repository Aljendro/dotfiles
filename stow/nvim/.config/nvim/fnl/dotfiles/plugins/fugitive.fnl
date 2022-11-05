(module dotfiles.plugins.fugitive)

;; Open up Fugitive in a tab
(kmap :n "<leader>gg" ":tab Git<cr>")
;; Create diffsplit
(kmap :n "<leader>gd" ":tab split<cr>:Gvdiffsplit<cr>")
;; Load changes into quickfix list
(kmap :n "<leader>gq" ":Git difftool<cr>:cclose<cr>")
;; Load diffs into tabs
(kmap :n "<leader>gD" ":Git difftool -y<cr>:cclose<cr>")
;; Open git blame with commit and author
(kmap :n "<leader>gb" ":Git blame<cr>A" {:silent true})
;; Refresh difftool
(kmap :n "<leader>gu" ":diffupdate<cr>")
;; Choose left buffer
(kmap :n "<leader>gh" ":diffget //2<cr>")
;; Choose the right buffer
(kmap :n "<leader>gl" ":diffget //3<cr>")
;; Traverse git merge conflict markers
(kmap :n "n" ":call v:lua.DiffContext(true)<CR>")
(kmap :n "n" ":call v:lua.DiffContext(false)<CR>")

