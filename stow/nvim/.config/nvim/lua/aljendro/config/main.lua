-- Neovim init settings
--
-- Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
--
require('aljendro/config/packer');

vim.cmd("source $HOME/.config/nvim/config/functions.vim")
vim.cmd("source $HOME/.config/nvim/config/core.vim")

require('luatab').setup({})
require('telescope').load_extension('fzf')
require('gitsigns').setup()
require('hop').setup({keys = 'fjdksla;rueiwovmcxtyz', term_seq_bias = 0.5})
require('nvim-ts-autotag').setup()
require('nvim-treesitter.configs').setup({
    ensure_installed = 'all',
    highlight = {enable = true, additional_vim_regex_highlighting = false},
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_decremental = "grm",
            node_incremental = "grn",
            scope_incremental = "grc"
        }
    },
    indent = {enable = true}
})
require('neoclip').setup()
require('lualine').setup({options = {theme = 'dracula'}})

require('aljendro/config/dap');
require('aljendro/config/lsp');
require('aljendro/config/auto-completion');
require('aljendro/config/plugins/nvim-tree');

