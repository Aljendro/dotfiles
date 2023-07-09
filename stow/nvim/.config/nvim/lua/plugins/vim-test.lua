return {
    "vim-test/vim-test",
    keys = {
        { "<leader>tt", ":TestNearest<cr>" },
        { "<leader>tf", ":TestFile<cr>" },
        { "<leader>ta", ":TestSuite<cr>" },
        { "<leader>tl", ":TestLast<cr>" },
        { "<leader>tv", ":TestVisit<cr>" },
    },
    config = function()
        vim.g["test#strategy"] = "neovim"
        vim.g["test#neovim#term_position"] = "vert"
    end,
}
