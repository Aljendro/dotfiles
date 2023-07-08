return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-treesitter/playground" },
    config = function() require("dotfiles.plugins.treesitter") end,
};
