require('neoscroll').setup({mappings = {}, hide_cursor = true})

local helper = require('aljendro/config/helper')
local toggled = false

function ToggleSmoothScroll()

    pcall(helper.del_keymap, 'n', '<C-k>')
    pcall(helper.del_keymap, 'n', '<C-j>')
    pcall(helper.del_keymap, 'n', '<M-k>')
    pcall(helper.del_keymap, 'n', '<M-j>')
    pcall(helper.del_keymap, 'n', '<Up>')
    pcall(helper.del_keymap, 'n', '<Down>')

    pcall(helper.del_keymap, 'x', '<C-k>')
    pcall(helper.del_keymap, 'x', '<C-j>')
    pcall(helper.del_keymap, 'x', '<M-k>')
    pcall(helper.del_keymap, 'x', '<M-j>')
    pcall(helper.del_keymap, 'x', '<Up>')
    pcall(helper.del_keymap, 'x', '<Down>')

    if toggled then
        -- Reset the keybindings with the base ones
        local opts = {noremap = true, silent = true}
        helper.set_keymap('n', '<C-k>', '<C-u>', opts)
        helper.set_keymap('n', '<C-j>', '<C-d>', opts)
        helper.set_keymap('n', '<M-k>', '<C-b>', opts)
        helper.set_keymap('n', '<M-j>', '<C-f>', opts)
        helper.set_keymap('n', '<Up>', '5<C-y>', opts)
        helper.set_keymap('n', '<Down>', '5<C-e>', opts)

        helper.set_keymap('x', '<C-k>', '<C-u>', opts)
        helper.set_keymap('x', '<C-j>', '<C-d>', opts)
        helper.set_keymap('x', '<M-k>', '<C-b>', opts)
        helper.set_keymap('x', '<M-j>', '<C-f>', opts)
        helper.set_keymap('x', '<Up>', '5<C-y>', opts)
        helper.set_keymap('x', '<Down>', '5<C-e>', opts)
    else
        local t = {}
        -- Syntax: t[keys] = {function, {function arguments}}
        t['<C-k>'] = {'scroll', {'-vim.wo.scroll', 'true', '100'}}
        t['<C-j>'] = {'scroll', {'vim.wo.scroll', 'true', '100'}}
        t['<M-k>'] = {
            'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '150'}
        }
        t['<M-j>'] = {
            'scroll', {'vim.api.nvim_win_get_height(0)', 'true', '150'}
        }
        t['<Up>'] = {'scroll', {'-0.10', 'false', '25'}}
        t['<Down>'] = {'scroll', {'0.10', 'false', '25'}}

        require('neoscroll.config').set_mappings(t)
    end

    toggled = not toggled
end

ToggleSmoothScroll()

