return require('packer').startup(function()

    use {
        'AckslD/nvim-neoclip.lua',
        module = {'telescope'},
        config = function() require('neoclip').setup({}) end
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
    use {'kyazdani42/nvim-web-devicons'}
    use {'alvarosevilla95/luatab.nvim'}
    use {
        'benmills/vimux',
        cmd = {
            'VimuxPromptCommand', 'VimuxRunLastCommand', 'VimuxInspectRunner',
            'VimuxCloseRunner', 'VimuxInterruptRunner'
        }
    }
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
        }
    }
    use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install'}
    use {'junegunn/fzf'}
    use {'junegunn/fzf.vim'}
    use {'kana/vim-textobj-entire'}
    use {'kana/vim-textobj-user'}
    use {'karb94/neoscroll.nvim'}
    use {
        'kyazdani42/nvim-tree.lua',
        cmd = {'NvimTreeFindFile', 'NvimTreeToggle'},
        config = function() require('aljendro/config/plugins/nvim-tree') end
    }
    use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}
    -- use {'mfussenegger/nvim-dap', config = function() require('aljendro/config/dap') end }
    use {'neovim/nvim-lspconfig'}
    use {
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup() end
    }
    use {'nvim-lualine/lualine.nvim'}
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
    use {
        'nvim-telescope/telescope.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = function()
            require('telescope').setup({
                defaults = {
                    layout_strategy = 'vertical',
                    layout_config = {
                        height = 0.99,
                        width = 0.99,
                        preview_height = 0.45
                    }
                }
            })
            require('telescope').load_extension('fzf')
        end
    }
    use {'nvim-treesitter/nvim-treesitter'}
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
    use {'windwp/nvim-ts-autotag'}

end)
