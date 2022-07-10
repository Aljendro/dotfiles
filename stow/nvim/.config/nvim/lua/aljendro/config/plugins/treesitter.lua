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
