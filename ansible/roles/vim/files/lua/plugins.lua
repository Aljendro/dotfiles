vim.g["loaded_perl_provider"] = 0
vim.g["loaded_ruby_provider"] = 0
vim.g["loaded_python_provider"] = 0
vim.g["node_host_prog"] = vim.fn.expand(
                              "~/.nvm/versions/node/v14.17.1/bin/neovim-node-host")
vim.g["python3_host_prog"] = vim.fn.expand("/usr/bin/python3")

return require('packer').startup(function()

    use "Pocco81/DAPInstall.nvim"
    use 'benmills/vimux'
    use 'davidgranstrom/nvim-markdown-preview'
    use 'dracula/vim'
    use 'godlygeek/tabular'
    use 'guns/vim-sexp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/nvim-cmp'
    use 'junegunn/fzf.vim'
    use 'vim-test/vim-test'
    use 'kabouzeid/nvim-lspinstall'
    use 'ryanoasis/vim-devicons'
    use 'tpope/vim-sleuth'
    use 'kana/vim-textobj-entire'
    use 'kana/vim-textobj-user'
    use 'kyazdani42/nvim-web-devicons'
    use 'mfussenegger/nvim-dap'
    use 'neovim/nvim-lspconfig'
    use 'nvim-telescope/telescope-dap.nvim'
    use 'olical/conjure'
    use 'p00f/nvim-ts-rainbow'
    use 'quangnguyen30192/cmp-nvim-ultisnips'
    use 'raimondi/delimitmate'
    use 'scrooloose/nerdtree'
    use 'sirver/ultisnips'
    use 'stefandtw/quickfix-reflector.vim'
    use 'tpope/vim-commentary'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-repeat'
    use 'tpope/vim-surround'
    use 'tpope/vim-unimpaired'
    use 'vim-scripts/LargeFile'
    use 'wbthomason/packer.nvim'
    use 'windwp/nvim-ts-autotag'
    use {
        "AckslD/nvim-neoclip.lua",
        config = function() require('neoclip').setup() end
    }
    use {
        'alvarosevilla95/luatab.nvim',
        requires = 'kyazdani42/nvim-web-devicons'
    }
    use {
        'eraserhd/parinfer-rust',
        run = 'cargo build --release'
    }
    use {
        'hoob3rt/lualine.nvim',
        requires = {
            'kyazdani42/nvim-web-devicons',
            opt = true
        }
    }
    use {
        'junegunn/fzf',
        run = function() vim.fn['fzf#install()'](0) end
    }
    use {
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'}
    }
    use {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make'
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = {'nvim-lua/plenary.nvim'}
    }
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use {
        'phaazon/hop.nvim',
        as = 'hop'
    }
    use {
        'prettier/vim-prettier',
        run = 'npm -s install'
    }

end)

