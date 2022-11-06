(module dotfiles.languages.markdown)
{autoload {{: kbmap : current-buf} dotfiles.core.common}}

(set vim.opt_local.foldmethod "expr")
(set vim.opt_local.foldexpr (. vim.g "nvim_treesitter#foldexpr()"))

;; Reflow bases on column length
(kbmap current-buf :n "<leader>fm" "vapgq" {:noremap true})

(kbmap current-buf :n "<C-f>" ":MarkdownPreviewToggle<cr>" {:noremap true})

(kbmap current-buf :n "<silent>" "<leader><leader>c :lua ToggleListItem('✅')<cr>" {:noremap true})
(kbmap current-buf :n "<silent>" "<leader><leader>p :lua ToggleListItem('🚧')<cr>" {:noremap true})
(kbmap current-buf :n "<silent>" "<leader><leader>r :lua ToggleListItem('🚀')<cr>" {:noremap true})

