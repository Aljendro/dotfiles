set runtimepath^=~/.vim
set runtimepath+=~/.vim/after
let &packpath = &runtimepath

let g:loaded_perl_provider   = 0
let g:loaded_ruby_provider   = 0
let g:loaded_python_provider = 0
let g:node_host_prog         = expand("~/.nvm/versions/node/v12.13.0/bin/neovim-node-host")
let g:python3_host_prog      = expand("/usr/bin/python3")

source ~/.vimrc

