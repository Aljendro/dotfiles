return require('packer').startup(function()

    use {
        'AckslD/nvim-neoclip.lua',
        module = {'telescope'},
        config = function() require('neoclip').setup({}) end
    }
    use {
        "Pocco81/auto-save.nvim",
        config = function() require('auto-save').setup({}) end
    }
    use {
        'Pocco81/DAPInstall.nvim',
        cmd = {'DIInstall', 'DIUninstall', 'DIList'}
    }
    use {
        'ThePrimeagen/harpoon',
        requires = {'nvim-lua/plenary.nvim'},
        module = {'harpoon.mark', 'harpoon.ui'},
        config = function()
            require('harpoon').setup({
                menu = {width = vim.api.nvim_win_get_width(0) - 4}
            })
        end
    }
    use {
        'j-hui/fidget.nvim',
        config = function() require('fidget').setup({}) end
    }
    use {'kyazdani42/nvim-web-devicons'}
    use {'benmills/vimux'}
    use {'chrisbra/NrrwRgn'}
    use {
        'eraserhd/parinfer-rust',
        run = 'cargo build --release',
        ft = {'clojure'}
    }
    use {'folke/tokyonight.nvim'}
    use {'godlygeek/tabular'}
    use {'guns/vim-sexp', ft = {'clojure'}}
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            {'quangnguyen30192/cmp-nvim-ultisnips'}, {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-nvim-lsp'}, {'hrsh7th/cmp-path'}
        },
        config = function()
            require('aljendro/config/plugins/auto-completion');
        end
    }
    use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install'}
    use {'kana/vim-textobj-entire'}
    use {'kana/vim-textobj-user'}
    use {
        'karb94/neoscroll.nvim',
        config = function() require('aljendro/config/plugins/neoscroll') end
    }
    use {
        'kyazdani42/nvim-tree.lua',
        cmd = {'NvimTreeFindFile', 'NvimTreeToggle'},
        config = function() require('aljendro/config/plugins/nvim-tree') end
    }
    use {
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = function() require('aljendro/config/plugins/gitsigns') end
    }
    -- use {'mfussenegger/nvim-dap', config = function() require('aljendro/config/plugins/dap') end }
    use {'mg979/vim-visual-multi'}
    use {
        'neovim/nvim-lspconfig',
        config = function() require('aljendro/config/plugins/lsp'); end
    }
    use {
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup({}) end
    }
    use {
        'nvim-lualine/lualine.nvim',
        config = function() require('aljendro/config/plugins/lualine') end
    }
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
    use {
        'nvim-telescope/telescope.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = function() require('aljendro/config/plugins/telescope') end
    }
    use {
        'nvim-treesitter/nvim-treesitter',
        config = function() require('aljendro/config/plugins/treesitter') end
    }
    use {'olical/conjure', ft = {'clojure'}}
    use {'p00f/nvim-ts-rainbow'}
    use {
        'phaazon/hop.nvim',
        cmd = {
            'HopWord', 'HopLine', 'HopChar1', 'HopWord', 'HopLine', 'HopChar1',
            'HopWord', 'HopLine', 'HopChar1'
        },
        config = function()
            require('hop').setup({
                keys = 'fjdksla;rueiwovmcxtyz',
                term_seq_bias = 0.5
            })
        end
    }
    use {'raimondi/delimitmate', event = {'InsertEnter'}}
    use {'sirver/ultisnips'}
    use {'stefandtw/quickfix-reflector.vim', ft = {'qf'}}
    use {'tpope/vim-fugitive', cmd = {'Git', 'Gvdiffsplit'}}
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
    use {
        'windwp/nvim-ts-autotag',
        config = function() require('nvim-ts-autotag').setup({}) end
    }

end)
