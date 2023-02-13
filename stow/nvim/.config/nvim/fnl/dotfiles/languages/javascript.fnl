(module dotfiles.language.javascript
   {autoload {{: kbmap : kbmapset : current-buf} dotfiles.core.common}})

(defn jest-debug-nearest []
  (let [original-executable (. vim.g "test#javascript#jest#executable")]
   (tset vim.g "test#javascript#jest#executable" "node --inspect-brk $(which jest)")
   (vim.cmd "TestNearest")
   (tset vim.g "test#javascript#jest#executable" original-executable)))

(defn setup []
   ;; Options
   (set vim.opt_local.foldmethod "expr")
   (set vim.opt_local.foldexpr "nvim_treesitter#foldexpr()")

   ;; Testing
   (tset vim.g "test#javascript#runner" "jest")
   (tset vim.g "test#javascript#jest#file_pattern" "\\v(__tests__/.*|(spec|test|integration))\\.(js|jsx|ts|tsx)$")
   (tset vim.g "test#javascript#jest#options" "--testRegex=\"(/__tests__/.*|(\\.|/)(test|spec|integration))\\.[jt]sx?$\"")
   (vim.cmd "iabbrev <buffer> d; debugger;")
   (kbmapset current-buf :n "<leader>ti" jest-debug-nearest)

   ;; Running scripts
   (kbmap current-buf :n "<leader>rr" ":call VimuxRunCommand('node ' . expand('%:p') . ' ')<left><left>")
   (kbmap current-buf :n "<leader>ri" ":call VimuxRunCommand('node --inspect-brk ' . expand('%:p') . ' ')<left><left>"))

