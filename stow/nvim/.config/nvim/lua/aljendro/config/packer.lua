return require('packer').startup(function()

    use {'AckslD/nvim-neoclip.lua'}
    use {
        'Pocco81/DAPInstall.nvim',
        cmd = {'DIInstall', 'DIUninstall', 'DIList'}
    }
    use {'ThePrimeagen/harpoon', requires = {'nvim-lua/plenary.nvim'}}
    use {'kyazdani42/nvim-web-devicons'}
    use {'alvarosevilla95/luatab.nvim'}
    use {'benmills/vimux'}
    use {
        'eraserhd/parinfer-rust',
        run = 'cargo build --release',
        ft = {'clojure'}
    }
    use {'folke/tokyonight.nvim'}
    use {'godlygeek/tabular', cmd = 'Tabularize'}
    use {'guns/vim-sexp', ft = {'clojure'}}
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            {'quangnguyen30192/cmp-nvim-ultisnips'}, {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-nvim-lsp'}, {'hrsh7th/cmp-path'}
        }
    }
    use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install'}
    use {'junegunn/fzf'}
    use {'junegunn/fzf.vim'}
    use {'kana/vim-textobj-entire'}
    use {'kana/vim-textobj-user'}
    use {'kyazdani42/nvim-tree.lua'}
    use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}
    use {'mfussenegger/nvim-dap'}
    use {'neovim/nvim-lspconfig'}
    use {'nvim-lualine/lualine.nvim'}
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
    use {'nvim-telescope/telescope.nvim', requires = {'nvim-lua/plenary.nvim'}}
    use {'nvim-treesitter/nvim-treesitter'}
    use {'olical/conjure', ft = {'clojure'}}
    use {'p00f/nvim-ts-rainbow'}
    use {'phaazon/hop.nvim'}
    use {'raimondi/delimitmate'}
    use {'sirver/ultisnips'}
    use {'stefandtw/quickfix-reflector.vim'}
    use {'tpope/vim-commentary'}
    use {'tpope/vim-fugitive'}
    use {'tpope/vim-repeat'}
    use {'tpope/vim-sleuth'}
    use {'tpope/vim-surround'}
    use {
        'vim-test/vim-test',
        cmd = {'TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit'}
    }
    use {'wellle/targets.vim'}
    use {'wbthomason/packer.nvim'}
    use {
        'williamboman/nvim-lsp-installer',
        cmd = {
            'LspInstall', 'LspInstallInfo', 'LspInstallLog', 'LspUninstall',
            'LspUninstallAll'
        }
    }
    use {'windwp/nvim-ts-autotag'}

end)
