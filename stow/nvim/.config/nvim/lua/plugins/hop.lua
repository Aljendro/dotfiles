return {
    "phaazon/hop.nvim",
    keys = {
        { "<leader>k", "<cmd>HopWord<cr>", mode = { "n", "x", "o" } },
        { "<leader>l", "<cmd>HopChar1<cr>", mode = { "n", "x", "o" } },
    },
    config = function()
        local c = require("common")
        require("hop").setup({
            keys = "fjdksla;rueiwovmcxtyz",
            term_seq_bias = 0.5,
        })
    end,
}
