(module dotfiles.plugins.gitsigns
  {autoload {{: kbmapset} dotfiles.core.common}})

(let [(ok? gitsigns) (pcall require "gitsigns")]
  (when ok?
    (gitsigns.setup
      {:on_attach
       (fn [bufnr]
         (let [gs package.loaded.gitsigns]
           (kbmapset bufnr :n "]c"
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
           (kbmapset bufnr :n "[c"
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
           (kbmapset bufnr :n "<leader>hs" ":Gitsigns stage_hunk<cr>")
           (kbmapset bufnr :v "<leader>hs" ":Gitsigns stage_hunk<cr>")
           (kbmapset bufnr :n "<leader>hr" ":Gitsigns reset_hunk<cr>")
           (kbmapset bufnr :v "<leader>hr" ":Gitsigns reset_hunk<cr>")
           (kbmapset bufnr :n "<leader>hS" gs.stage_buffer)
           (kbmapset bufnr :n "<leader>hu" gs.undo_stage_hunk)
           (kbmapset bufnr :n "<leader>hR" gs.reset_buffer)
           (kbmapset bufnr :n "<leader>hp" gs.preview_hunk)
           (kbmapset bufnr :n "<leader>ho" gs.toggle_deleted)
           (kbmapset bufnr :n "<leader>hb" (fn [] (gs.blame_line {:full true})))
           (kbmapset bufnr :n "<leader>hd" (fn [] (gs.diffthis)))
           (kbmapset bufnr :n "<leader>hD" (fn [] (gs.diffthis "~")))))})))

