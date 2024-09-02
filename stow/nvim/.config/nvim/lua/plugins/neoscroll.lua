return {
    "karb94/neoscroll.nvim",
    config = function()
        require("neoscroll").setup({ mappings = {}, hide_cursor = true })
        ToggleSmoothScroll()
    end,
}
