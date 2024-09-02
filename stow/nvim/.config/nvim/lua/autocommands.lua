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
    callback = function()
        MakeSession("default")
    end,
})

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = customVim,
    pattern = table.concat({
        "*.edn",
        "*.clj",
        "*.cljc",
        "*.cljs",
        "*.css",
        "*.fnl",
        "*.go",
        "*.html",
        "*.js",
        "*.json",
        "*.jsonl",
        "*.jsx",
        "*.lua",
        "*.md",
        "*.py",
        "*.rs",
        "*.ts",
        "*.tsx",
        "*.txt",
        "*.yaml",
        "*.yml",
        "*.hbs",
        "*.cpp",
        "*.c",
        "*.h",
        "*.hpp",
    }, ","),
    callback = function()
        vim.cmd("silent! w")
    end,
})

vim.api.nvim_create_autocmd({ "QuickFixCmdPost" }, {
    group = customVim,
    pattern = "[^l]*",
    callback = function()
        vim.cmd("cwindow")
    end,
})

vim.api.nvim_create_autocmd({ "QuickFixCmdPost" }, {
    group = customVim,
    pattern = "l*",
    callback = function()
        vim.cmd("lwindow")
    end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    group = customVim,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
    end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = customVim,
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end,
})
