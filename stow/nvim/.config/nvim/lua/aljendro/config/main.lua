-- Neovim init settings
--
-- Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
--
require('aljendro/config/packer');

vim.cmd('source $HOME/.config/nvim/config/functions.vim')
vim.cmd('source $HOME/.config/nvim/config/core.vim')

require('luatab').setup({})
require('gitsigns').setup({
    on_attach = function()
        local helper = require('aljendro/config/helper')
        local opts = {noremap = true, silent = true}
        helper.buf_set_keymap('n', '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>',
                              opts)
        helper.buf_set_keymap('v', '<leader>hs', ':Gitsigns stage_hunk<CR>',
                              opts)
        helper.buf_set_keymap('n', '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>',
                              opts)
        helper.buf_set_keymap('v', '<leader>hr', ':Gitsigns reset_hunk<CR>',
                              opts)
        helper.buf_set_keymap('n', '<leader>hu',
                              '<cmd>Gitsigns undo_stage_hunk<CR>', opts)
        helper.buf_set_keymap('n', '<leader>hp',
                              '<cmd>Gitsigns preview_hunk<CR>', opts)
    end
})
require('nvim-ts-autotag').setup({})
require('nvim-treesitter.configs').setup({
    ensure_installed = 'maintained',
    highlight = {enable = true, additional_vim_regex_highlighting = false},
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<leader>y',
            node_decremental = '<leader>u',
            node_incremental = '<leader>i'
        }
    },
    indent = {enable = true}
})
require('lualine').setup({options = {theme = 'tokyonight'}})

require('aljendro/config/lsp');
require('aljendro/config/auto-completion');
require('aljendro/config/plugins/neoscroll');

