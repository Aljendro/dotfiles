(module dotfiles.language.javascript
   {autoload {{: kbmap : current-buf} dotfiles.core.common}})

(defn setup []
   (vim.cmd "iabbrev <buffer> d; debugger;")
   (set vim.opt_local.foldmethod "expr")
   (set vim.opt_local.foldexpr "nvim_treesitter#foldexpr()")

   (tset vim.g "test#javascript#runner" "jest")
   (tset vim.g "test#javascript#jest#file_pattern" "\\v(__tests__/.*|(spec|test|integration))\\.(js|jsx|ts|tsx)$")
   (tset vim.g "test#javascript#jest#options" "--testMatch \"**/__tests__/**/*.[jt]s?(x)\", \"**/?(*.)+(spec|test|integration).[jt]s?(x)\"")

   (kbmap current-buf :n "<leader>rr" ":call VimuxRunCommand('node ' . expand('%:p') . ' ')<left><left>")
   (kbmap current-buf :n "<leader>ri" ":call VimuxRunCommand('node --inspect-brk ' . expand('%:p') . ' ')<left><left>"))

