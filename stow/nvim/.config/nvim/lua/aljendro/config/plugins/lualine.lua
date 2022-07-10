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
