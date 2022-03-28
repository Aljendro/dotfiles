require('neoscroll').setup({mappings = {}, hide_cursor = true})

local helper = require('aljendro/config/helper')
local toggled = false

function ToggleSmoothScroll()

    pcall(helper.del_keymap, 'n', '<C-k>')
    pcall(helper.del_keymap, 'n', '<C-j>')
    pcall(helper.del_keymap, 'n', '<Up>')
    pcall(helper.del_keymap, 'n', '<Down>')

    pcall(helper.del_keymap, 'x', '<C-k>')
    pcall(helper.del_keymap, 'x', '<C-j>')
    pcall(helper.del_keymap, 'x', '<Up>')
    pcall(helper.del_keymap, 'x', '<Down>')

    if toggled then
        -- Reset the keybindings with the base ones
        local opts = {noremap = true, silent = true}
        helper.set_keymap('n', '<C-k>', '<C-b>', opts)
        helper.set_keymap('n', '<C-j>', '<C-f>', opts)
        helper.set_keymap('n', '<Up>', '5<C-y>', opts)
        helper.set_keymap('n', '<Down>', '5<C-e>', opts)

        helper.set_keymap('x', '<C-k>', '<C-b>', opts)
        helper.set_keymap('x', '<C-j>', '<C-f>', opts)
        helper.set_keymap('x', '<Up>', '5<C-y>', opts)
        helper.set_keymap('x', '<Down>', '5<C-e>', opts)
    else
        local t = {}
        -- Syntax: t[keys] = {function, {function arguments}}
        t['<C-k>'] = {
            'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '250'}
        }
        t['<C-j>'] = {
            'scroll', {'vim.api.nvim_win_get_height(0)', 'true', '250'}
        }
        t['<Up>'] = {'scroll', {'-0.20', 'false', '150'}}
        t['<Down>'] = {'scroll', {'0.20', 'false', '150'}}

        require('neoscroll.config').set_mappings(t)
    end

    toggled = not toggled
end

ToggleSmoothScroll()

