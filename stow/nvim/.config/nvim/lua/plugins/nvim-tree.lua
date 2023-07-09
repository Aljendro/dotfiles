return {
    "kyazdani42/nvim-tree.lua",
    commit = "8b8d457",
    keys = {
        { ";df", ":NvimTreeFindFile<cr>" },
        { ";dd", ":NvimTreeToggle<cr>" },
        { ";dc", ":NvimTreeCollapse<cr>" },
    },
    config = function()
        local c = require("common")
        local nvim_tree = require("nvim-tree")
        local nvim_tree_config = require("nvim-tree.config")
        local list = {
            { key = "CD", cb = nvim_tree_config.nvim_tree_callback("cd") },
            { key = "S",
              cb = nvim_tree_config.nvim_tree_callback("system_open") },
            { key = { "<CR>", "o", "<2-LeftMouse>" }, action = "edit" },
            { key = "O", action = "edit_no_picker" },
            { key = "<C-v>", action = "vsplit" },
            { key = "<C-t>", action = "tabnew" },
            { key = "<", action = "prev_sibling" },
            { key = ">", action = "next_sibling" },
            { key = "P", action = "parent_node" },
            { key = "<BS>", action = "close_node" },
            { key = "<Tab>", action = "preview" },
            { key = "K", action = "first_sibling" },
            { key = "J", action = "last_sibling" },
            { key = "I", action = "toggle_ignored" },
            { key = "H", action = "toggle_dotfiles" },
            { key = "R", action = "refresh" },
            { key = "a", action = "create" },
            { key = "d", action = "remove" },
            { key = "D", action = "trash" },
            { key = "r", action = "rename" },
            { key = "<C-r>", action = "full_rename" },
            { key = "x", action = "cut" },
            { key = "c", action = "copy" },
            { key = "p", action = "paste" },
            { key = "y", action = "copy_name" },
            { key = "Y", action = "copy_path" },
            { key = "gy", action = "copy_absolute_path" },
            { key = "[c", action = "prev_git_item" },
            { key = "]c", action = "next_git_item" },
            { key = "-", action = "dir_up" },
            { key = "q", action = "close" },
            { key = "g?", action = "toggle_help" },
        }
        nvim_tree.setup({
            actions = { change_dir = { global = true } },
            update_cwd = true,
            view = { mappings = { custom_only = true, list = list } },
            renderer = {
                group_empty = true,
                indent_markers = { enable = true },
                icons = {
                    show = {
                        git = true,
                        folder = true,
                        file = true,
                        folder_arrow = false,
                    },
                },
            },
        })
    end,
};
