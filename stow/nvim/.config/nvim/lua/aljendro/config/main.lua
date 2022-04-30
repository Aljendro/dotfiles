-- Neovim init settings
--
-- Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
--
require('aljendro/config/packer');

vim.cmd('source $HOME/.config/nvim/config/functions.vim')
vim.cmd('source $HOME/.config/nvim/config/core.vim')

require('gitsigns').setup({
    on_attach = function(bufnr)
        local opts = {noremap = true, silent = true}
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>hs',
                                    '<cmd>Gitsigns stage_hunk<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>hs',
                                    ':Gitsigns stage_hunk<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>hr',
                                    '<cmd>Gitsigns reset_hunk<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>hr',
                                    ':Gitsigns reset_hunk<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>hu',
                                    '<cmd>Gitsigns undo_stage_hunk<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>hp',
                                    '<cmd>Gitsigns preview_hunk<CR>', opts)
    end
})
require('nvim-ts-autotag').setup({})
require('nvim-treesitter.configs').setup({
    ensure_installed = 'all',
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
require('lualine').setup({
    options = {theme = 'tokyonight', globalstatus = true},
    sections = {lualine_c = {{'filename', path = 1}}},
    tabline = {
        lualine_a = {{'buffers', mode = 0}},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {'tabs'}
    }
})
require('autosave').setup({})

require('aljendro/config/lsp');
require('aljendro/config/auto-completion');
require('aljendro/config/plugins/neoscroll');

