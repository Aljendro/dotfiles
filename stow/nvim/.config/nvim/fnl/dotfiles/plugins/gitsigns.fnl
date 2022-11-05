(module dotfiles.plugins.gitsigns
  {autoload {{: kbmap} dotfiles.core.common
             : gitsigns}})

(gitsigns.setup
  {:on_attach
   (fn [bufnr]
     (let [gs package.loaded.gitsigns]
       (kbmap bufnr :n "]c"
         (fn []
           (if vim.wo.diff
             "]c"
             (do
               (vim.schedule
                 (fn []
                   (gs.next_hunk)
                   (vim.cmd "normal! zz")))
               "<Ignore>")))
         {:expr true})
       (kbmap bufnr :n "[c"
         (fn []
           (if vim.wo.diff
             "[c"
             (do
               (vim.schedule
                 (fn []
                   (gs.next_hunk)
                   (vim.cmd "normal! zz")))
               "<Ignore>")))
         {:expr true})
       (kbmap bufnr :n "<leader>hs" ":Gitsigns stage_hunk<cr>")
       (kbmap bufnr :v "<leader>hs" ":Gitsigns stage_hunk<cr>")
       (kbmap bufnr :n "<leader>hr" ":Gitsigns reset_hunk<cr>")
       (kbmap bufnr :v "<leader>hr" ":Gitsigns reset_hunk<cr>")
       (kbmap bufnr :n "<leader>hS" gs.stage_buffer)
       (kbmap bufnr :n "<leader>hu" gs.undo_stage_hunk)
       (kbmap bufnr :n "<leader>hR" gs.reset_buffer)
       (kbmap bufnr :n "<leader>hp" gs.preview_hunk)
       (kbmap bufnr :n "<leader>ho" gs.toggle_deleted)
       (kbmap bufnr :n "<leader>hb" (fn [] (gs.blame_line {:full true})))
       (kbmap bufnr :n "<leader>hd" (fn [] (gs.diffthis)))
       (kbmap bufnr :n "<leader>hD" (fn [] (gs.diffthis "~")))))})

