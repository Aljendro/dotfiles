return {
    "windwp/nvim-ts-autotag",
    ft = { "javascriptreact", "typescriptreact", "html" },
    config = function()
        require("nvim-ts-autotag").setup({})
    end,
}
