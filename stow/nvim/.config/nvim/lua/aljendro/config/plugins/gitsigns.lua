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
