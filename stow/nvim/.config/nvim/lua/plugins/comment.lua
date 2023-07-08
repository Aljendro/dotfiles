return {
    "numtostr/comment.nvim",
    dependencies = { "joosepalviste/nvim-ts-context-commentstring" },
    config = function() require("dotfiles.plugins.comment-plugin").setup() end,
}
