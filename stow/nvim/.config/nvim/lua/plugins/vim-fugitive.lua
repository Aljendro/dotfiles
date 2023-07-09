return {
    "tpope/vim-fugitive",
    keys = {
        -- Open up Fugitive in a tab
        { "<leader>gg", ":tab Git<cr>" },
        -- Create diffsplit
        { "<leader>gd", ":tab split<cr>:Gvdiffsplit<cr>" },
        -- Load changes into quickfix list
        { "<leader>gq", ":Git difftool<cr>:cclose<cr>" },
        -- Load diffs into tabs
        { "<leader>gD", ":Git difftool -y<cr>:cclose<cr>" },
        -- Open git blame with commit and author
        { "<leader>gb", ":Git blame<cr>A" },
        -- Refresh difftool
        { "<leader>gu", ":diffupdate<cr>" },
        -- Choose left buffer
        { "<leader>gh", ":diffget //2<cr>" },
        -- Choose the right buffer
        { "<leader>gl", ":diffget //3<cr>" },
        -- Traverse git merge conflict markers
        { "]n", ":lua DiffContext(true)<cr>" },
        { "[n", ":lua DiffContext(false)<cr>" },

    },
    config = function()
        local c = require("common")
        -- Replace conflict keybindings
        vim.cmd("let g:nremap = {'s': 'S'}")
        vim.cmd("let g:xremap = {'s': 'S'}")

        vim.cmd(
            "cnoreabbrev <expr> gf v:lua.CommandAbbreviation('gf', 'Git fetch origin')")
        vim.cmd(
            "cnoreabbrev <expr> gb v:lua.CommandAbbreviation('gb', 'Git branch')")
        vim.cmd(
            "cnoreabbrev <expr> gbd v:lua.CommandAbbreviation('gbd', 'Git branch -d ')")
        vim.cmd(
            "cnoreabbrev <expr> gbdr v:lua.CommandAbbreviation('gbdr', 'Git push origin --delete')")
        vim.cmd(
            "cnoreabbrev <expr> gpl v:lua.CommandAbbreviation('gpl', 'Git pull')")
        vim.cmd(
            "cnoreabbrev <expr> ggpull v:lua.CommandAbbreviation('ggpull', 'Git pull origin <C-R>=FugitiveHead()<cr>')")
        vim.cmd(
            "cnoreabbrev <expr> gp v:lua.CommandAbbreviation('gp', 'Git push')")
        vim.cmd(
            "cnoreabbrev <expr> ggpush v:lua.CommandAbbreviation('ggpush', 'Git push origin <C-R>=FugitiveHead()<cr>')")
        vim.cmd(
            "cnoreabbrev <expr> gco v:lua.CommandAbbreviation('gco', 'Git checkout')")
        vim.cmd(
            "cnoreabbrev <expr> gcb v:lua.CommandAbbreviation('gcb', 'Git checkout -b ')")
        vim.cmd(
            "cnoreabbrev <expr> gcd v:lua.CommandAbbreviation('gcd', 'Git checkout develop')")
        vim.cmd(
            "cnoreabbrev <expr> gcm v:lua.CommandAbbreviation('gcm', 'Git checkout main')")
        vim.cmd(
            "cnoreabbrev <expr> gac v:lua.CommandAbbreviation('gac', 'Git commit -a -m ')")
        vim.cmd(
            "cnoreabbrev <expr> gsta v:lua.CommandAbbreviation('gsta', 'Git stash push -u -m ')")
        vim.cmd(
            "cnoreabbrev <expr> gstd v:lua.CommandAbbreviation('gstd', 'Git stash drop')")
        vim.cmd(
            "cnoreabbrev <expr> gstl v:lua.CommandAbbreviation('gstl', 'Git stash list')")
        vim.cmd(
            "cnoreabbrev <expr> gstp v:lua.CommandAbbreviation('gstp', 'Git stash pop')")
    end,
}
