return {
    "phaazon/hop.nvim",
    branch = "v2",
    keys = {
        { "<leader>k", "<cmd>HopWordMW<cr>", mode = { "n", "x", "o" } },
        { "<leader>j", "<cmd>HopChar1MW<cr>", mode = { "n", "x", "o" } },
    },
    config = function()
        require("hop").setup({ keys = "fjdksla;rueiwovmcxtyz", term_seq_bias = 0.5 })
    end,
}
