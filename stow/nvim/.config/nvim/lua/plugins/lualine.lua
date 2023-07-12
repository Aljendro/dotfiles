return {
    "nvim-lualine/lualine.nvim",
    config = function()
        require("lualine").setup {
            options = { theme = "tokyonight", globalstatus = true },
            sections = { lualine_c = { { "filename", path = 1 } }, lualine_x = { "encoding", "fileformat", "filetype" } },
            tabline = {
                lualine_a = { { "buffers", mode = 4 } },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = { "tabs" },
            },
        }
    end,
}
