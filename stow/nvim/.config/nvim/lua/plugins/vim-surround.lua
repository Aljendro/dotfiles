return {
    "tpope/vim-surround",
    config = function()
        local c = require("common")
        c.kmap("n", "<leader>'", "ysiw'", { noremap = false })
        c.kmap("n", "<leader>\"", "ysiw\"", { noremap = false })
        c.kmap("n", "<leader>`", "ysiw`", { noremap = false })
        c.kmap("n", "<leader>)", "ysiw)", { noremap = false })
        c.kmap("n", "<leader>}", "ysiw}", { noremap = false })
        c.kmap("n", "<leader>]", "ysiw]", { noremap = false })
    end,
}
