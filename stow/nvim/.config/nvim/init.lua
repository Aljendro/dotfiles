-- Neovim init settings
--
-- Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
--
vim.o.termguicolors = true

-- Install Lazy.nvim if not installed
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Leader Keys
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Enable Aniseed's automatic compilation and loading of Fennel source code.
vim.g['aniseed#env'] = { module = 'dotfiles.init', compile = true }

require('lazy').setup({
    {
        'anuvyklack/pretty-fold.nvim',
        config = function()
            require('pretty-fold').setup({
                fill_char = '━',
                sections = { left = { 'content' } },
            })
        end,
    },
    {
        'norcalli/nvim-colorizer.lua',
        ft = { 'css', 'scss', 'html' },
        config = function() require('colorizer').setup() end,
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp-signature-help',
        },
        config = function() require('dotfiles.plugins.cmp').setup() end,
    },
    {
        'ThePrimeagen/harpoon',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function() require('dotfiles.plugins.harpoon').setup() end,
    },
    { 'kyazdani42/nvim-web-devicons' },
    { 'chrisbra/NrrwRgn' },
    { 'David-Kunz/cmp-npm', dependencies = { 'nvim-lua/plenary.nvim' } },
    {
        'eraserhd/parinfer-rust',
        build = 'cargo build --release',
        ft = { 'clojure', 'fennel' },
    },
    { 'folke/tokyonight.nvim' },
    { 'godlygeek/tabular' },
    {
        'iamcco/markdown-preview.nvim',
        ft = { 'markdown' },
        build = 'cd app && yarn install',
    },
    {
        'karb94/neoscroll.nvim',
        config = function() require('dotfiles.plugins.neoscroll').setup() end,
    },
    {
        'kosayoda/nvim-lightbulb',
        config = function()
            require('nvim-lightbulb').setup({ autocmd = { enabled = true } })
        end,
    },
    {
        'kyazdani42/nvim-tree.lua',
        commit = '8b8d457',
        config = function() require('dotfiles.plugins.nvim-tree').setup() end,
    },
    {
        'L3MON4D3/LuaSnip',
        version = 'v1.*',
        dependencies = { 'rafamadriz/friendly-snippets' },
        config = function()
            local ls = require('luasnip')
            ls.config.set_config({
                enable_autosnippets = true,
                history = true,
                update_events = 'TextChanged,TextChangedI',
                store_selection_keys = '<tab>',
            })
            require('luasnip.loaders.from_snipmate').load({
                path = { os.getenv('HOME') .. '/.config/nvim/snippets' },
            })
            require('luasnip.loaders.from_lua').load({
                paths = os.getenv('HOME') .. '/.config/nvim/snippets',
            })
            vim.api.nvim_create_user_command('LuaSnipEdit', function()
                require('luasnip.loaders').edit_snippet_files({
                    edit = function(fileName)
                        vim.cmd('vsplit ' .. fileName)
                    end,
                })
            end, {})
        end,
    },
    {
        'lewis6991/gitsigns.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function() require('dotfiles.plugins.gitsigns') end,
    },
    { 'mg979/vim-visual-multi' },
    {
        'neovim/nvim-lspconfig',
        ft = {
            'javascript',
            'javascriptreact',
            'typescript',
            'typescriptreact',
            'json',
            'html',
            'css',
            'lua',
            'clojure',
            'dockerfile',
            'rust',
            'go',
            'python',
            'bash',
            'sh',
        },
        config = function() require('dotfiles.plugins.lspconfig').setup() end,
    },
    {
        'numToStr/Comment.nvim',
        dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
        config = function()
            require('dotfiles.plugins.comment-plugin').setup()
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        config = function() require('dotfiles.plugins.lualine') end,
    },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            {
                'AckslD/nvim-neoclip.lua',
                config = function()
                    require('neoclip').setup({
                        default_register = { '"', '+', '*' },
                    })
                end,
            },
        },
        config = function() require('dotfiles.plugins.telescope').setup() end,
    },
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = { 'nvim-treesitter/playground' },
        config = function() require('dotfiles.plugins.treesitter') end,
    },
    { 'olical/aniseed' },
    { 'olical/nvim-local-fennel' },
    { 'olical/conjure', ft = { 'clojure', 'fennel' } },
    { 'p00f/nvim-ts-rainbow' },
    {
        'phaazon/hop.nvim',
        config = function()
            require('hop').setup({
                keys = 'fjdksla;rueiwovmcxtyz',
                term_seq_bias = 0.5,
            })
        end,
    },
    { 'stefandtw/quickfix-reflector.vim', ft = { 'qf' } },
    { 'tpope/vim-fugitive' },
    { 'tpope/vim-repeat' },
    { 'tpope/vim-sleuth' },
    { 'tpope/vim-surround' },
    { 'vim-test/vim-test' },
    { 'WhoIsSethDaniel/lualine-lsp-progress.nvim' },
    {
        'windwp/nvim-ts-autotag',
        ft = { 'javascriptreact', 'typescriptreact', 'html' },
        config = function() require('nvim-ts-autotag').setup({}) end,
    },
    {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup({
                disable_filetype = { 'TelescopePrompt', 'clojure', 'fennel' },
            })
        end,
    },
    {
        'github/copilot.vim',
        config = function() require('dotfiles.plugins.copilot') end,
    },
})

local customVim = vim.api.nvim_create_augroup('customVim', { clear = true })
vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
    group = customVim,
    pattern = '*',
    callback = function()
        vim.cmd([[
            if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
            \|   exe "normal! g`\""
            \| endif
        ]])
    end,
})
vim.api.nvim_create_autocmd({ 'VimLeave' }, {
    group = customVim,
    pattern = '*',
    callback = function() MakeSession('default') end,
})
vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
    group = customVim,
    pattern = '*.txt,*.sh,*.md,*.html,*.yml,*.yaml,*.css,*.js,*.ts,*.jsx,*.tsx,*.json,*.jsonl,*.py,*.rs,*.go,*.lua,*.fnl,*.clj,*.cljs,*.cljc',
    callback = function() vim.cmd('silent! w') end,
})
vim.api.nvim_create_autocmd({ 'QuickFixCmdPost' }, {
    group = customVim,
    pattern = '[^l]*',
    callback = function() vim.cmd('cwindow') end,
})
vim.api.nvim_create_autocmd({ 'QuickFixCmdPost' }, {
    group = customVim,
    pattern = 'l*',
    callback = function() vim.cmd('lwindow') end,
})
vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
    group = customVim,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank { higroup = 'IncSearch', timeout = 150 }
    end,
})
