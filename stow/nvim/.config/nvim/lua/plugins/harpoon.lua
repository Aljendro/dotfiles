return {
    "theprimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("dotfiles.plugins.harpoon").setup() end,
}
