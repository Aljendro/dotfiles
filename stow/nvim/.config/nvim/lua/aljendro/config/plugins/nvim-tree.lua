local tree_cb = require('nvim-tree.config').nvim_tree_callback

local opts = {noremap = true, silent = true}
vim.api.nvim_set_keymap('n', ';d', ':NvimTreeToggle<cr>', opts)
vim.api.nvim_set_keymap('n', ';D', ':NvimTreeFindFile<cr>', opts)

vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_show_icons = {
    ['git'] = 1,
    ['folders'] = 1,
    ['files'] = 1,
    ['folder_arrows'] = 0
}

local list = {
    {key = {'CD'}, cb = tree_cb('cd')}, {key = 's'},
    {key = 'S', cb = tree_cb('system_open')}
}

require('nvim-tree').setup({
    update_cwd = true,
    view = {mappings = {list = list}}
})
