return {
    "vim-test/vim-test",
    config = function()
        local c = require("common")

        vim.g["test#strategy"] = "neovim"
        vim.g["test#neovim#term_position"] = "vert"

        c.kmap("n", "<leader>tt", ":TestNearest<cr>")
        c.kmap("n", "<leader>tf", ":TestFile<cr>")
        c.kmap("n", "<leader>ta", ":TestSuite<cr>")
        c.kmap("n", "<leader>tl", ":TestLast<cr>")
        c.kmap("n", "<leader>tv", ":TestVisit<cr>")
    end,
}
