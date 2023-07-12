vim.api.nvim_create_autocmd(
    { "BufRead", "BufNewFile" },
    {
        pattern = "*.jsonl",
        callback = function()
            vim.bo.filetype = "jsonl"
        end,
    }
)
