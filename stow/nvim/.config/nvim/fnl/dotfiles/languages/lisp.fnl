(module dotfiles.languages.lisp
  {autoload {{: kbmap : current-buf} dotfiles.core.common}})

(defn setup []
  (tset vim.g "conjure#highlight#enabled" true)
  (tset vim.g "conjure#highlight#timeout" 250)
  (tset vim.g "conjure#log#wrap" true)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; REPL
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ; Opening the REPL
  (kbmap current-buf :n "<leader>cc" "<localleader>lv" {:noremap false})
  (kbmap current-buf :n "<leader>ct" "<localleader>lt" {:noremap false})
  ; Clear the REPL window
  (kbmap current-buf :n "<leader>cr" "<localleader>lr" {:noremap false})
  ; Reset the REPL
  (kbmap current-buf :n "<leader>cR" "<localleader>lR" {:noremap false})
  ; Closing the REPL
  (kbmap current-buf :n "<leader>cq" "<localleader>lq" {:noremap false})
  ; Enter at bottom of REPL
  (kbmap current-buf :n "<leader>ci" "Go" {:noremap true})

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Evaluations
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ; Evaluate Form Under Cursor
  (kbmap current-buf :n "<leader>ee" "<localleader>ee" {:noremap false})
  ; Evaluate Root Form Under Cursor
  (kbmap current-buf :n "<leader>er" "<localleader>er" {:noremap false})
  ; Evaluate Editor Line
  (kbmap current-buf :n "<leader>el" "<S-v><localleader>E" {:noremap false})
  ; Evaluate Form under cursor and replace with result
  (kbmap current-buf :n "<leader>eo" "<localleader>e!" {:noremap false})
  ; Evaluate Word under cursor
  (kbmap current-buf :n "<leader>ew" "<localleader>ew" {:noremap false})
  ; Evaluate File from disk
  (kbmap current-buf :n "<leader>ef" "<localleader>ef" {:noremap false})
  ; Evaluate File from buffer
  (kbmap current-buf :n "<leader>eb" "<localleader>eb" {:noremap false})
  ; Go to documentation file
  (kbmap current-buf :n "<leader>ed" "<localleader>gd" {:noremap false})
  ; Evaluate form at mark
  (kbmap current-buf :n "<leader>em" "<localleader>em" {:noremap false}))

