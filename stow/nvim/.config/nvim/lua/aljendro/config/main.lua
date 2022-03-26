-- Neovim init settings
--
-- Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
--
require('aljendro/config/packer');

vim.cmd('source $HOME/.config/nvim/config/functions.vim')
vim.cmd('source $HOME/.config/nvim/config/core.vim')

require('luatab').setup({})
require('telescope').setup({
    defaults = {
        layout_strategy = 'vertical',
        layout_config = {height = 0.99, width = 0.99, preview_height = 0.45}
    }
})
require('telescope').load_extension('fzf')
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
require('hop').setup({keys = 'fjdksla;rueiwovmcxtyz', term_seq_bias = 0.5})
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
require('neoclip').setup({})
require('lualine').setup({options = {theme = 'tokyonight'}})
require('harpoon').setup({menu = {width = vim.api.nvim_win_get_width(0) - 4}})
require('Comment').setup()

require('aljendro/config/dap');
require('aljendro/config/lsp');
require('aljendro/config/auto-completion');
require('aljendro/config/plugins/nvim-tree');
require('aljendro/config/plugins/neoscroll');

