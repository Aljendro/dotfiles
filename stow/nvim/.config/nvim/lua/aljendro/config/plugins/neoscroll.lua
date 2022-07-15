require('neoscroll').setup({mappings = {}, hide_cursor = true})

local toggled = true
function ToggleSmoothScroll()

    pcall(vim.api.nvim_del_keymap, 'n', '<C-k>')
    pcall(vim.api.nvim_del_keymap, 'n', '<C-j>')
    pcall(vim.api.nvim_del_keymap, 'n', '<Up>')
    pcall(vim.api.nvim_del_keymap, 'n', '<Down>')
    pcall(vim.api.nvim_del_keymap, 'n', '<PageDown>')
    pcall(vim.api.nvim_del_keymap, 'n', '<PageUp>')

    pcall(vim.api.nvim_del_keymap, 'x', '<C-k>')
    pcall(vim.api.nvim_del_keymap, 'x', '<C-j>')
    pcall(vim.api.nvim_del_keymap, 'x', '<Up>')
    pcall(vim.api.nvim_del_keymap, 'x', '<Down>')
    pcall(vim.api.nvim_del_keymap, 'x', '<PageDown>')
    pcall(vim.api.nvim_del_keymap, 'x', '<PageUp>')

    if toggled then
        -- Reset the keybindings with the base ones
        local opts = {noremap = true, silent = true}
        vim.api.nvim_set_keymap('n', '<C-k>', '<C-u>', opts)
        vim.api.nvim_set_keymap('n', '<C-j>', '<C-d>', opts)
        vim.api.nvim_set_keymap('n', '<PageUp>', '<C-b>', opts)
        vim.api.nvim_set_keymap('n', '<PageDown>', '<C-f>', opts)
        vim.api.nvim_set_keymap('n', '<Up>', '5<C-y>', opts)
        vim.api.nvim_set_keymap('n', '<Down>', '5<C-e>', opts)

        vim.api.nvim_set_keymap('x', '<C-k>', '<C-u>', opts)
        vim.api.nvim_set_keymap('x', '<C-j>', '<C-d>', opts)
        vim.api.nvim_set_keymap('x', '<PageUp>', '<C-b>', opts)
        vim.api.nvim_set_keymap('x', '<PageDown>', '<C-f>', opts)
        vim.api.nvim_set_keymap('x', '<Up>', '5<C-y>', opts)
        vim.api.nvim_set_keymap('x', '<Down>', '5<C-e>', opts)
    else
        local t = {}
        t['<C-j>'] = {'scroll', {'vim.wo.scroll', 'true', '150'}}
        t['<C-k>'] = {'scroll', {'-vim.wo.scroll', 'true', '150'}}
        t['<PageDown>'] = {
            'scroll', {'vim.api.nvim_win_get_height(0)', 'true', '250'}
        }
        t['<PageUp>'] = {
            'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '250'}
        }
        t['<Up>'] = {'scroll', {'-0.20', 'false', '100'}}
        t['<Down>'] = {'scroll', {'0.20', 'false', '100'}}

        require('neoscroll.config').set_mappings(t)
    end

    toggled = not toggled
end

ToggleSmoothScroll()

