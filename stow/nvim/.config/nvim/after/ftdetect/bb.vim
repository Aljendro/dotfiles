autocmd BufNewFile,BufRead * if getline(1) == '#!/usr/bin/env bb' | set ft=clojure | endif
