return {
    "bbjornstad/pretty-fold.nvim",
    commit = "ce302faec7da79ea8afb5a6eec5096b68ba28cb5",
    keys = {
        -- Easier folds
        { "<leader>fj", "zrzz" },
        { "<leader>fk", "zmzz" },
        { "<leader>fh", "zMzz" },
        { "<leader>fl", "zRzz" },
        { "<leader>fo", "zozz" },
        { "<leader>fo", "zozz" },
        { "<leader>fO", "zOzz" },
        { "<leader>fO", "zOzz" },
        { "<leader>fc", "zczz" },
        { "<leader>fc", "zczz" },
        { "<leader>fC", "zCzz" },
        { "<leader>fC", "zCzz" },
        { "<leader>fe", "mazMzv`azczOzz" },
        -- Reset Folds
        { "<leader>fr", "zx" },
    },
    config = function()
        require("pretty-fold").setup({ fill_char = "━", sections = { left = { "content" } } })
    end,
}
