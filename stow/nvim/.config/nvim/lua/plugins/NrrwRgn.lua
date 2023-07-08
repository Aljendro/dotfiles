return {
    "chrisbra/nrrwrgn",
    config = function()
        local c = require("common")
        vim.g.nrrw_rgn_vert = true
        vim.g.nrrw_rgn_resize_window = "relative"
        c.kmap("x", "<leader>z", "<Plug>NrrwrgnDo", { silent = true })
    end,
}
