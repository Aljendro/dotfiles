(module dotfiles.plugins.hop
  {autoload {{: kmap} dotfiles.core.common}})

;; 1-character
(kmap :n "<leader>k" "<cmd>HopWord<cr>" {:silent true})
(kmap :n "<leader>j" "<cmd>HopLine<cr>" {:silent true})
(kmap :n "<leader>l" "<cmd>HopChar1<cr>" {:silent true})
;; visual-mode
(kmap :x "<leader>k" "<cmd>HopWord<cr>" {:silent true})
(kmap :x "<leader>j" "<cmd>HopLine<cr>" {:silent true})
(kmap :x "<leader>l" "<cmd>HopChar1<cr>" {:silent true})
;; operator-pending-mode
(kmap :o "<leader>k" "<cmd>HopWord<cr>" {:silent true})
(kmap :o "<leader>j" "<cmd>HopLine<cr>" {:silent true})
(kmap :o "<leader>l" "<cmd>HopChar1<cr>" {:silent true})

