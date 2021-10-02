vim.g["loaded_perl_provider"] = 0
vim.g["loaded_ruby_provider"] = 0
vim.g["loaded_python_provider"] = 0
vim.g["node_host_prog"] = vim.fn.expand("~/.nvm/versions/node/v14.17.1/bin/neovim-node-host")
vim.g["python3_host_prog"] = vim.fn.expand("/usr/bin/python3")

return require('packer').startup(function()

  use 'Xuyuanp/nerdtree-git-plugin'
  use 'airblade/vim-gitgutter'
  use 'alvan/vim-closetag'
  use 'benmills/vimux'
  use 'godlygeek/tabular'
  use 'guns/vim-sexp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/nvim-cmp'
  use 'itchyny/lightline.vim'
  use 'junegunn/fzf.vim'
  use 'justinmk/vim-sneak'
  use 'kana/vim-textobj-entire'
  use 'kana/vim-textobj-user'
  use 'luochen1990/rainbow'
  use 'morhetz/gruvbox'
  use 'neovim/nvim-lspconfig'
  use 'olical/conjure'
  use 'quangnguyen30192/cmp-nvim-ultisnips'
  use 'raimondi/delimitmate'
  use 'scrooloose/nerdtree'
  use 'sheerun/vim-polyglot'
  use 'sirver/ultisnips'
  use 'stefandtw/quickfix-reflector.vim'
  use 'stsewd/fzf-checkout.vim'
  use 'tpope/vim-commentary'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'
  use 'wbthomason/packer.nvim'
  use { 'eraserhd/parinfer-rust', run = 'cargo build --release' }
  use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install' }
  use { 'junegunn/fzf', run = function() vim.fn['fzf#install()'](0) end }
  use { 'prettier/vim-prettier', run = 'npm -s install' }

end)

