return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        {
            "AckslD/nvim-neoclip.lua",
            config = function()
                require("neoclip").setup(
                    { default_register = { "\"", "+", "*" } })
            end,
        },
    },
    config = function() require("dotfiles.plugins.telescope").setup() end,
};
