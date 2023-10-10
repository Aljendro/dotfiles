return {
    "nvim-lualine/lualine.nvim",
    config = function()
        require("lualine").setup {
            options = { theme = "tokyonight", globalstatus = true },
            sections = {
                lualine_b = { 'branch', 'diff', {
                    'diagnostics',
                    always_visible = false,
                    sections = { 'error', 'warn', 'info', 'hint' },
                    sources = { 'nvim_diagnostic' },
                    symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
                }
                },
                lualine_c = { { "filename", path = 1, file_status = true, symbols = { modified = '' } } }
            },
            tabline = {
                lualine_a = { { "tabs", use_mode_colors = true } },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
        }
    end,
}
