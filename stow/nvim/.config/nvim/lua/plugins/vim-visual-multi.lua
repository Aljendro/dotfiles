return {
    "mg979/vim-visual-multi",
    config = function()
        -- Settings
        vim.g.VM_theme = "neon"
        vim.g.VM_silent_exit = true

        -- Keybindings
        vim.g.VM_leader = "<bslash>"
        vim.g.VM_mouse_mappings = true
    end,
}
