local customVim = vim.api.nvim_create_augroup("customVim", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    group = customVim,
    pattern = "*",
    callback = function()
        vim.cmd([[
            if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
            \|   exe "normal! g`\""
            \| endif
        ]])
    end,
})
vim.api.nvim_create_autocmd({ "VimLeave" }, {
    group = customVim,
    pattern = "*",
    callback = function() MakeSession("default") end,
})
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = customVim,
    pattern = "*.txt,*.sh,*.md,*.html,*.yml,*.yaml,*.css,*.js,*.ts,*.jsx,*.tsx,*.json,*.jsonl,*.py,*.rs,*.go,*.lua,*.fnl,*.clj,*.cljs,*.cljc",
    callback = function() vim.cmd("silent! w") end,
})
vim.api.nvim_create_autocmd({ "QuickFixCmdPost" }, {
    group = customVim,
    pattern = "[^l]*",
    callback = function() vim.cmd("cwindow") end,
})
vim.api.nvim_create_autocmd({ "QuickFixCmdPost" }, {
    group = customVim,
    pattern = "l*",
    callback = function() vim.cmd("lwindow") end,
})
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    group = customVim,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank { higroup = "IncSearch", timeout = 150 }
    end,
})