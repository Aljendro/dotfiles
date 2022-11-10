-- Neovim init settings
--
-- Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
--
vim.o.termguicolors = true
require('packer').startup(function()

    use {
        'norcalli/nvim-colorizer.lua',
        ft = {'css', 'scss', 'html'},
        config = function() require('colorizer').setup() end
    }
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            {'quangnguyen30192/cmp-nvim-ultisnips'}, {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-nvim-lsp'}, {'hrsh7th/cmp-path'},
            {'hrsh7th/cmp-cmdline'}, {'hrsh7th/cmp-nvim-lsp-signature-help'}
        },
        config = function() require('dotfiles.plugins.cmp').setup() end
    }
    use {
        'ThePrimeagen/harpoon',
        requires = {'nvim-lua/plenary.nvim'},
        module = {'harpoon.mark', 'harpoon.ui'},
        config = function() require('dotfiles.plugins.harpoon').setup() end
    }
    use {'kyazdani42/nvim-web-devicons'}
    use {
        'benmills/vimux',
        cmd = {
            'VimuxPromptCommand', 'VimuxRunLastCommand', 'VimuxInspectRunner',
            'VimuxCloseRunner', 'VimuxInterruptRunner',
            'VimuxClearTerminalScreen', 'VimuxClearRunnerHistory',
            'VimuxZoomRunner', 'VimuxRunCommand'
        }
    }
    use {'chrisbra/NrrwRgn'}
    use {
        'eraserhd/parinfer-rust',
        run = 'cargo build --release',
        ft = {'clojure', 'fennel'}
    }
    use {'folke/tokyonight.nvim'}
    use {'godlygeek/tabular'}
    use {
        'iamcco/markdown-preview.nvim',
        ft = {'markdown'},
        run = 'cd app && yarn install'
    }
    use {'kana/vim-textobj-entire'}
    use {'kana/vim-textobj-user'}
    use {
        'karb94/neoscroll.nvim',
        module = {'neoscroll', 'neoscroll.config'},
        config = function() require('dotfiles.plugins.neoscroll').setup() end
    }
    use {
        'kosayoda/nvim-lightbulb',
        config = function()
            require('nvim-lightbulb').setup({autocmd = {enabled = true}})
        end
    }
    use {
        'kyazdani42/nvim-tree.lua',
        cmd = {'NvimTreeFindFile', 'NvimTreeToggle'},
        config = function() require('dotfiles.plugins.nvim-tree').setup() end
    }
    use {
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = function() require('dotfiles.plugins.gitsigns') end
    }
    use {'mg979/vim-visual-multi'}
    use {
        'neovim/nvim-lspconfig',
        requires = {
            'hrsh7th/nvim-cmp',
            requires = {
                {'quangnguyen30192/cmp-nvim-ultisnips'}, {'hrsh7th/cmp-buffer'},
                {'hrsh7th/cmp-nvim-lsp'}, {'hrsh7th/cmp-path'},
                {'hrsh7th/cmp-cmdline'}, {'hrsh7th/cmp-nvim-lsp-signature-help'}
            },
            config = function()
                require('dotfiles.plugins.cmp').setup()
            end
        },
        ft = {
            'javascript', 'javascriptreact', 'typescript', 'typescriptreact',
            'json', 'html', 'css', 'lua', 'clojure', 'dockerfile', 'rust', 'go',
            'python'
        },
        config = function() require('dotfiles.plugins.lspconfig').setup() end
    }
    use {
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup({}) end
    }
    use {
        'nvim-lualine/lualine.nvim',
        config = function() require('dotfiles.plugins.lualine') end
    }
    use {
        'nvim-telescope/telescope.nvim',
        cmd = {'Telescope'},
        module = {'telescope', 'telescope.builtin'},
        requires = {
            'nvim-lua/plenary.nvim',
            {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}, {
                'AckslD/nvim-neoclip.lua',
                config = function()
                    require('neoclip').setup({
                        default_register = {'"', '+', '*'}
                    })
                end
            }
        },
        config = function() require('dotfiles.plugins.telescope').setup() end
    }
    use {
        'nvim-treesitter/nvim-treesitter',
        requires = {'nvim-treesitter/playground'},
        config = function() require('dotfiles.plugins.treesitter') end
    }
    use {'olical/aniseed'}
    use {'olical/conjure', ft = {'clojure', 'fennel'}}
    use {'p00f/nvim-ts-rainbow'}
    use {
        'phaazon/hop.nvim',
        cmd = {'HopWord', 'HopChar1'},
        config = function()
            require('hop').setup({
                keys = 'fjdksla;rueiwovmcxtyz',
                term_seq_bias = 0.5
            })
        end
    }
    use {'sirver/ultisnips', event = {"InsertEnter"}}
    use {'stefandtw/quickfix-reflector.vim', ft = {'qf'}}
    use {'tpope/vim-fugitive'}
    use {'tpope/vim-repeat'}
    use {'tpope/vim-sleuth'}
    use {'tpope/vim-surround'}
    use {
        'vim-test/vim-test',
        cmd = {'TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit'}
    }
    use {'wbthomason/packer.nvim'}
    use {'WhoIsSethDaniel/lualine-lsp-progress.nvim'}
    use {
        'williamboman/nvim-lsp-installer',
        cmd = {
            'LspInstall', 'LspInstallInfo', 'LspInstallLog', 'LspUninstall',
            'LspUninstallAll'
        }
    }
    use {
        'windwp/nvim-ts-autotag',
        ft = {'javascriptreact', 'typescriptreact', 'html'},
        config = function() require('nvim-ts-autotag').setup({}) end
    }
    use {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({
                disable_filetype = {"TelescopePrompt", "clojure", "fennel"}
            })
        end
    }

end)

vim.cmd([[

augroup customVim
      autocmd!
      " When editing a file, always jump to the last known cursor position.
      autocmd BufReadPost *
                        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
                        \ |   exe "normal! g`\""
                        \ | endif
      " Create a default session when vim leaves
      autocmd VimLeave * :call v:lua.MakeSession('default')
      " Open quickfix after command that populates it is run
      autocmd QuickFixCmdPost [^l]* cwindow
      autocmd QuickFixCmdPost l* lwindow
      " Highlight the movement selection
      autocmd TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=150 }
augroup END

]])

-- Enable Aniseed's automatic compilation and loading of Fennel source code.
vim.g["aniseed#env"] = {module = "dotfiles.init", compile = true}

