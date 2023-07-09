return {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
        local c = require("common")
        vim.g.copilot_no_tab_map = true
        c.kmap("i", "<C-h>", "<Plug>(copilot-suggest)", { silent = true })
        c.kmap("i", "<C-l>", "copilot#Accept(\"\\<CR>\")",
               { silent = true, script = true, expr = true })
        vim.cmd(
            "cnoreabbrev <expr> cp v:lua.CommandAbbreviation('cp', 'vert Copilot panel')")
        vim.cmd(
            "cnoreabbrev <expr> cr v:lua.CommandAbbreviation('cr', 'Copilot refresh')")
    end,
}