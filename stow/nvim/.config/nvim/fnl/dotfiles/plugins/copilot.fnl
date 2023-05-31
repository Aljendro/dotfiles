(module dotfiles.plugins.copilot
  {autoload {{: kmap} dotfiles.core.common}})

;; Give a completion for Copilot
(tset vim.g "copilot_no_tab_map" true)
(kmap :i "<C-h>" "<Plug>(copilot-suggest)" {:silent true})
(kmap :i "<C-l>" "copilot#Accept(\"\\<CR>\")" {:silent true :script true :expr true})

;; Disable Copilot for all filetypes
; (tset vim.g "copilot_filetypes" {:* false})

(vim.cmd "cnoreabbrev <expr> cp v:lua.CommandAbbreviation('cp', 'vert Copilot panel')")
(vim.cmd "cnoreabbrev <expr> cr v:lua.CommandAbbreviation('cr', 'Copilot refresh')")

