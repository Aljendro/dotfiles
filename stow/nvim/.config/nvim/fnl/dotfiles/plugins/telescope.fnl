(module dotfiles.plugins.telescope
  {autoload {{: kmap} dotfiles.core.common}})

(telescope.setup
  {:defaults
   {:mappings
    {:i {"<C-j>" actions.move_selection_next
         "<C-k>" actions.move_selection_previous}
     :n {"<C-j>" actions.move_selection_next
         "<C-k>" actions.move_selection_previous}}
    :cache_picker {:num_pickers 20}
    :layout_strategy "flex"
    :layout_config {:height 0.95
                    :width 0.95
                    :vertical {:preview_height 0.45}
                    :horizontal {:preview_width 0.50}}}})

(telescope.load_extension "fzf")

(kmap :n ";/" ":lua require('telescope.builtin').search_history()<cr>")
(kmap :n ";;" ":lua require('telescope.builtin').command_history()<cr>")
(kmap :x ";;" ":lua require('telescope.builtin').command_history()<cr>")
(kmap :n ";a" ":lua require('telescope.builtin').autocommands()<cr>")
(kmap :n ";b" ":lua require('telescope.builtin').buffers({sort_mru=true})<cr>")
(kmap :n ";B" ":lua require('telescope.builtin').builtin()<cr>")
(kmap :n ";c" ":lua require('telescope.builtin').commands()<cr>")
(kmap :n ";f" ":lua require('telescope.builtin').find_files({hidden=true})<cr>")
(kmap :n ";gc" ":lua require('telescope.builtin').git_bcommits()<cr>")
(kmap :n ";gC" ":lua require('telescope.builtin').git_commits()<cr>")
(kmap :n ";gb" ":lua require('telescope.builtin').git_branches()<cr>")
(kmap :n ";gf" ":lua require('telescope.builtin').git_files()<cr>")
(kmap :n ";gg" ":lua require('telescope.builtin').live_grep()<cr>")
(kmap :n ";gs" ":lua require('telescope.builtin').git_stash()<cr>")
(kmap :n ";h" ":lua require('telescope.builtin').help_tags()<cr>")
(kmap :n ";j" ":lua require('telescope.builtin').jumplist({ignore_filename=false})<cr>")
(kmap :n ";k" ":lua require('telescope.builtin').keymaps()<cr>")
(kmap :n ";ll" ":lua require('telescope.builtin').loclist()<cr>")
(kmap :n ";ld" ":lua require('telescope.builtin').diagnostics({bufnr=0})<cr>")
(kmap :n ";lm" ":lua require('telescope.builtin').man_pages()<cr>")
(kmap :n ";ls" ":lua require('telescope.builtin').lsp_document_symbols()<cr>")
(kmap :n ";lD" ":lua require('telescope.builtin').diagnostics()<cr>")
(kmap :n ";lS" ":lua require('telescope.builtin').lsp_workspace_symbols({query=''})<left><left><left>")
(kmap :n ";m" ":lua require('telescope.builtin').marks()<cr>")
(kmap :n ";n" ":lua require('telescope').extensions.neoclip.default()<cr>")
(kmap :n ";of" ":lua require('telescope.builtin').oldfiles()<cr>")
(kmap :n ";p" ":lua require('telescope.builtin').pickers()<cr>")
(kmap :n ";q" ":lua require('telescope.builtin').quickfix()<cr>")
(kmap :n ";r" ":lua require('telescope.builtin').resume()<cr>")
(kmap :n ";R" ":lua require('telescope.builtin').registers()<cr>")
(kmap :n ";s" ":lua require('telescope.builtin').current_buffer_fuzzy_find({skip_empty_lines=true})<cr>")
(kmap :n ";t" ":lua require('telescope.builtin').treesitter()<cr>")
(kmap :n ";vf" ":lua require('telescope.builtin').filetypes()<cr>")
(kmap :n ";vo" ":lua require('telescope.builtin').vim_options()<cr>")
(kmap :n ";w" ":Telescope grep_string<cr>")
(kmap :x ";w" ":call v:lua.GetSelectedTextGrep()<cr>:Telescope grep_string additional_args={'-F'} search=<C-R>=@/<cr><cr>")

