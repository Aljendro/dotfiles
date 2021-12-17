local tree_cb = require('nvim-tree.config').nvim_tree_callback
local helper = require('aljendro/config/helper')

local opts = {noremap = true, silent = true}
vim.api.nvim_set_keymap('n', ';d', ':NvimTreeToggle<cr>', opts)
vim.api.nvim_set_keymap('n', ';D', ':NvimTreeFindFile<cr>', opts)

vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_show_icons = {
    ['git'] = 1,
    ['folders'] = 1,
    ['files'] = 1,
    ['folder_arrows'] = 0
}

-- default mappings
local list = {
    -- { key = {"<CR>", "o", "<2-LeftMouse>"}, cb = tree_cb("edit") },
    {key = {'CD'}, cb = tree_cb("cd")},
    -- { key = "<C-v>",                        cb = tree_cb("vsplit") },
    -- { key = "<C-x>",                        cb = tree_cb("split") },
    -- { key = "<C-t>",                        cb = tree_cb("tabnew") },
    -- { key = "<",                            cb = tree_cb("prev_sibling") },
    -- { key = ">",                            cb = tree_cb("next_sibling") },
    -- { key = "P",                            cb = tree_cb("parent_node") },
    -- { key = "<BS>",                         cb = tree_cb("close_node") },
    -- { key = "<S-CR>",                       cb = tree_cb("close_node") },
    -- { key = "<Tab>",                        cb = tree_cb("preview") },
    -- { key = "K",                            cb = tree_cb("first_sibling") },
    -- { key = "J",                            cb = tree_cb("last_sibling") },
    -- { key = "I",                            cb = tree_cb("toggle_ignored") },
    -- { key = "H",                            cb = tree_cb("toggle_dotfiles") },
    -- { key = "R",                            cb = tree_cb("refresh") },
    -- { key = "a",                            cb = tree_cb("create") },
    -- { key = "d",                            cb = tree_cb("remove") },
    -- { key = "D",                            cb = tree_cb("trash") },
    -- { key = "r",                            cb = tree_cb("rename") },
    -- { key = "<C-r>",                        cb = tree_cb("full_rename") },
    -- { key = "c",                            cb = tree_cb("copy") },
    -- { key = "p",                            cb = tree_cb("paste") },
    -- { key = "y",                            cb = tree_cb("copy_name") },
    -- { key = "Y",                            cb = tree_cb("copy_path") },
    -- { key = "gy",                           cb = tree_cb("copy_absolute_path") },
    -- { key = "[c",                           cb = tree_cb("prev_git_item") },
    -- { key = "]c",                           cb = tree_cb("next_git_item") },
    -- { key = "-",                            cb = tree_cb("dir_up") },
    {key = "s"}, {key = "S", cb = tree_cb("system_open")}
    -- { key = "q",                            cb = tree_cb("close") },
    -- { key = "g?",                           cb = tree_cb("toggle_help") },
}

require('nvim-tree').setup({view = {mappings = {list = list}}})
