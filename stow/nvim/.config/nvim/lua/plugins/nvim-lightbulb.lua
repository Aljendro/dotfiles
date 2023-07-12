return {
    "kosayoda/nvim-lightbulb",
    event = "CursorHold",
    config = function() require("nvim-lightbulb").setup({ autocmd = { enabled = true } }) end,
};
