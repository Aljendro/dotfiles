-- Neovim init settings
--
-- Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
--

vim.o.termguicolors = true
require('packer').startup(function()

    use {
        'norcalli/nvim-colorizer.lua',
        config = function() require('colorizer').setup() end
    }
    use {
        'AckslD/nvim-neoclip.lua',
        config = function()
            require('neoclip').setup({default_register = {'"', '+', '*'}})
        end
    }
    use {
        "doubleloop/auto-save.nvim",
        commit = "2f52da487b26a2eafed289ff78a6e8df52995f6f",
        config = function()
            require('auto-save').setup({
                trigger_events = {"InsertLeave", "TextChanged"}, -- vim events that trigger auto-save. See :h events
                -- function that determines whether to save the current buffer or not
                -- return true: if buffer is ok to be saved
                -- return false: if it's not ok to be saved
                condition = function(buf)
                    local fn = vim.fn
                    local utils = require("auto-save.utils.data")

                    if fn.getbufvar(buf, "&modifiable") == 1 and
                        utils.not_in(fn.getbufvar(buf, "&filetype"),
                                     {'TelescopePrompt', 'TelescopeResults'}) then
                        return true -- met condition(s), can save
                    end
                    return false -- can't save
                end
            })
        end
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
    use {'benmills/vimux'}
    use {'chrisbra/NrrwRgn'}
    use {
        'eraserhd/parinfer-rust',
        run = 'cargo build --release',
        ft = {'clojure', 'fennel'}
    }
    use {'folke/tokyonight.nvim'}
    use {'godlygeek/tabular'}
    use {'guns/vim-sexp', ft = {'clojure', 'fennel'}}
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            {'quangnguyen30192/cmp-nvim-ultisnips'}, {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-nvim-lsp'}, {'hrsh7th/cmp-path'},
            {'hrsh7th/cmp-cmdline'}, {'hrsh7th/cmp-nvim-lsp-signature-help'}
        },
        config = function()
            require('dotfiles.plugins.cmp');
        end
    }
    use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install'}
    use {'kana/vim-textobj-entire'}
    use {'kana/vim-textobj-user'}
    use {
        'karb94/neoscroll.nvim',
        config = function() require('dotfiles.plugins.neoscroll') end
    }
    use {
        'kosayoda/nvim-lightbulb',
        config = function()
            require('nvim-lightbulb').setup({autocmd = {enabled = true}})
        end
    }
    use {
        'kyazdani42/nvim-tree.lua',
        config = function() require('dotfiles.plugins.nvim-tree') end
    }
    use {
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = function() require('dotfiles.plugins.gitsigns') end
    }
    use {'mg979/vim-visual-multi'}
    use {
        'neovim/nvim-lspconfig',
        config = function() require('dotfiles.plugins.lspconfig'); end
    }
    use {
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup({}) end
    }
    use {
        'nvim-lualine/lualine.nvim',
        config = function() require('dotfiles.plugins.lualine') end
    }
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
    use {
        'nvim-telescope/telescope.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = function() require('dotfiles.plugins.telescope') end
    }
    use {
        'nvim-treesitter/nvim-treesitter',
        config = function() require('dotfiles.plugins.treesitter') end
    }
    use {'olical/aniseed'}
    use {'olical/conjure', ft = {'clojure', 'fennel'}}
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
    use {'sirver/ultisnips'}
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
    use {'wellle/targets.vim'}
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
        config = function() require('nvim-ts-autotag').setup({}) end
    }
    use {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({
                disable_filetype = {"TelescopePrompt", "clojure"}
            })
        end
    }

end)

vim.cmd([[

" Code signature
iabbrev @@ Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
" Quick Grep and Location/Quickfix List opens
cnoreabbrev <expr> grep v:lua.CommandAbbreviation('grep', "silent grep  \| copen<left><left><left><left><left><left><left><left>")
cnoreabbrev <expr> lgrep v:lua.CommandAbbreviation('lgrep', "silent lgrep  <C-r>=expand('%:p')<cr> \| lopen<C-b><right><right><right><right><right><right><right><right><right><right><right><right><right>")
noreabbrev _ml --multiline
noreabbrev _mla --multiline --multiline-dotall
" Non Greedy *
cnoreabbrev *? <left>\{-}<C-r>=v:lua.EatChar('\s')<cr>
" Always open help in new tab
cnoreabbrev <expr> tah v:lua.CommandAbbreviation('tah', 'tab help') . ' '
" Change filetype
cnoreabbrev <expr> ft v:lua.CommandAbbreviation('ft', 'set ft=')
" Split line by a character

cnoreabbrev <expr> qnf v:lua.CommandAbbreviation('qnf', 'cfdo set nofoldenable')

cnoreabbrev <expr> wdt v:lua.CommandAbbreviation('wdt', 'windo diffthis')

highlight WinSeparator guifg=#999999

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

let g:nremap = {'s': 'S'}
let g:xremap = {'s': 'S'}

cnoreabbrev <expr> gf v:lua.CommandAbbreviation('gf', 'Git fetch origin')
cnoreabbrev <expr> gb v:lua.CommandAbbreviation('gb', 'Git branch')
cnoreabbrev <expr> gbd v:lua.CommandAbbreviation('gbd', 'Git branch -d')
cnoreabbrev <expr> gbdr v:lua.CommandAbbreviation('gbdr', 'Git push origin --delete')
cnoreabbrev <expr> gpl v:lua.CommandAbbreviation('gpl', 'Git pull')
cnoreabbrev <expr> ggpull v:lua.CommandAbbreviation('ggpull', 'Git pull origin <C-R>=FugitiveHead()<cr>')
cnoreabbrev <expr> gp v:lua.CommandAbbreviation('gp', 'Git push')
cnoreabbrev <expr> ggpush v:lua.CommandAbbreviation('ggpush', 'Git push origin <C-R>=FugitiveHead()<cr>')
cnoreabbrev <expr> gco v:lua.CommandAbbreviation('gco', 'Git checkout')
cnoreabbrev <expr> gcb v:lua.CommandAbbreviation('gcb', 'Git checkout -b')
cnoreabbrev <expr> gcd v:lua.CommandAbbreviation('gcd', 'Git checkout develop')
cnoreabbrev <expr> gcm v:lua.CommandAbbreviation('gcm', 'Git checkout master')
cnoreabbrev <expr> gac v:lua.CommandAbbreviation('gac', 'Git commit -a -m')
cnoreabbrev <expr> gsta v:lua.CommandAbbreviation('gsta', 'Git stash push -u -m')
cnoreabbrev <expr> gstd v:lua.CommandAbbreviation('gstd', 'Git stash drop')
cnoreabbrev <expr> gstl v:lua.CommandAbbreviation('gstl', 'Git stash list')
cnoreabbrev <expr> gstp v:lua.CommandAbbreviation('gstp', 'Git stash pop')

highlight LspReference guifg=NONE guibg=#665c54 guisp=NONE gui=NONE cterm=NONE ctermfg=NONE ctermbg=59
highlight! link LspReferenceText LspReference
highlight! link LspReferenceRead LspReference
highlight! link LspReferenceWrite LspReference

cnoreabbrev <expr> t v:lua.CommandAbbreviation('t', "Tab /")

]])

-- Enable Aniseed's automatic compilation and loading of Fennel source code.
vim.g["aniseed#env"] = {module = "dotfiles.init", compile = false}

