return {
    "phaazon/hop.nvim",
    config = function()
        local c = require("common")
        require("hop").setup({
            keys = "fjdksla;rueiwovmcxtyz",
            term_seq_bias = 0.5,
        })
        -- 1-character
        c.kmap("n", "<leader>k", "<cmd>HopWord<cr>", {silent = true})
        c.kmap("n", "<leader>l", "<cmd>HopChar1<cr>", {silent = true})
        -- visual-mode
        c.kmap("x", "<leader>k", "<cmd>HopWord<cr>", {silent = true})
        c.kmap("x", "<leader>l", "<cmd>HopChar1<cr>", {silent = true})
        -- operator-pending-mode
        c.kmap("o", "<leader>k", "<cmd>HopWord<cr>", {silent = true})
        c.kmap("o", "<leader>l", "<cmd>HopChar1<cr>", {silent = true})
    end,
}
