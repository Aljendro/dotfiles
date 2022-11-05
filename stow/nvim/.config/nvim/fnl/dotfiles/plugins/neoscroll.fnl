(module dotfiles.plugins.neoscroll
  {autoload {{: kmap : kunmap} dotfiles.core.common
             : neoscroll
             neoscroll-config neoscroll.config}})

(neoscroll.setup {:mappings {} :hide_cursor true})

(var toggled false)
(defn ToggleSmoothScroll []
    (pcall kunmap "n" "<C-k>")
    (pcall kunmap "n" "<C-j>")
    (pcall kunmap "n" "<Up>")
    (pcall kunmap "n" "<Down>")
    (pcall kunmap "n" "<PageDown>")
    (pcall kunmap "n" "<PageUp>")

    (pcall kunmap "x" "<C-k>")
    (pcall kunmap "x" "<C-j>")
    (pcall kunmap "x" "<Up>")
    (pcall kunmap "x" "<Down>")
    (pcall kunmap "x" "<PageDown>")
    (pcall kunmap "x" "<PageUp>")

    (if toggled
      (do
        ;; Reset the keybindings with the base ones
        (kmap :n "<C-k>" "<C-u>")
        (kmap :n "<C-j>" "<C-d>")
        (kmap :n "<PageUp>" "<C-b>")
        (kmap :n "<PageDown>" "<C-f>")
        (kmap :n "<Up>" "5<C-y>")
        (kmap :n "<Down>" "5<C-e>")
        (kmap :x "<C-k>" "<C-u>")
        (kmap :x "<C-j>" "<C-d>")
        (kmap :x "<PageUp>" "<C-b>")
        (kmap :x "<PageDown>" "<C-f>")
        (kmap :x "<Up>" "5<C-y>")
        (kmap :x "<Down>" "5<C-e>"))
      (let [t {"<C-j>" [:scroll ["vim.wo.scroll" "true" "150"]]
               "<C-k>" [:scroll ["-vim.wo.scroll" "true" "150"]]
               "<PageDown>" [:scroll ["vim.api.nvim_win_get_height(0)" "true" "250"]]
               "<PageUp>" [:scroll ["-vim.api.nvim_win_get_height(0)" "true" "250"]]
               "<Up>" [:scroll ["-0.20" "false" "100"]]
               "<Down>" [:scroll ["0.20" "false" "100"]]}]
        (neoscroll-config.set_mappings t)))
    (set toggled (not toggled)))

(ToggleSmoothScroll)
