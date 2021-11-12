setlocal foldmethod=indent

noremap <expr> <leader>rs ':call VimuxRunCommand("cd ' . getcwd() . ';sls invoke local --function ' . expand("<cword>") . ' --stage ")<left><left>'
