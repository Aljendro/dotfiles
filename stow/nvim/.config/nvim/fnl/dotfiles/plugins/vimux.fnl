(module dotfiles.plugins.vimux
  {autoload {{: kmap} dotfiles.core.common}})

(kmap :n "<leader>vv" ":VimuxPromptCommand<cr>")
(kmap :n "<leader>vl" ":VimuxRunLastCommand<cr>")
(kmap :n "<leader>vi" ":VimuxInspectRunner<cr>")
(kmap :n "<leader>vq" ":VimuxCloseRunner<cr>")
(kmap :n "<leader>vs" ":VimuxInterruptRunner<cr>")
(kmap :n "<leader>vc" ":VimuxClearTerminalScreen<cr>")
(kmap :n "<leader>vC" ":VimuxClearRunnerHistory<cr>")
(kmap :n "<leader>vz" ":VimuxZoomRunner<cr>")

