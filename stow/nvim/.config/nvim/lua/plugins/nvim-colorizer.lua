return {
    "norcalli/nvim-colorizer.lua",
    ft = { "css", "scss", "html" },
    config = function()
        require("colorizer").setup()
    end,
}
