return {
    "chrisbra/nrrwrgn",
    keys = { { "<leader>z", "<Plug>NrrwrgnDo", mode = "x" } },
    config = function()
        local c = require("common")
        vim.g.nrrw_rgn_vert = true
        vim.g.nrrw_rgn_resize_window = "relative"
    end,
}
