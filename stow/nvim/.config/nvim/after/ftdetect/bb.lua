vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*",
    callback = function()
        local first_line = vim.fn.getline(1)
        if first_line == "#!/usr/bin/env bb" or first_line ==
            "#!/usr/bin/env nbb" then vim.bo.filetype = "clojure" end
    end,
})
