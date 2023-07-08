return {
    "phaazon/hop.nvim",
    config = function()
        require("hop").setup({
            keys = "fjdksla;rueiwovmcxtyz",
            term_seq_bias = 0.5,
        })
    end,
}
