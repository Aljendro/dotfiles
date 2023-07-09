return {
    "theprimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local c = require("common")
        require("harpoon").setup({
            menu = { width = vim.api.nvim_win_get_width(0) - 4 },
        })
        -- Regular Files
        c.kmap("n", "<leader>sa", ":lua require('harpoon.mark').add_file()<cr>")
        c.kmap("n", "<leader>sA",
               ":lua require('harpoon.ui').toggle_quick_menu()<cr>")
        c.kmap("n", "<leader>sm", ":lua require('harpoon.ui').nav_file(1)<cr>")
        c.kmap("n", "<leader>s,", ":lua require('harpoon.ui').nav_file(2)<cr>")
        c.kmap("n", "<leader>s.", ":lua require('harpoon.ui').nav_file(3)<cr>")
        c.kmap("n", "<leader>sj", ":lua require('harpoon.ui').nav_file(4)<cr>")
        c.kmap("n", "<leader>sk", ":lua require('harpoon.ui').nav_file(5)<cr>")
        c.kmap("n", "<leader>sl", ":lua require('harpoon.ui').nav_file(6)<cr>")
        c.kmap("n", "<leader>su", ":lua require('harpoon.ui').nav_file(7)<cr>")
        c.kmap("n", "<leader>si", ":lua require('harpoon.ui').nav_file(8)<cr>")
        c.kmap("n", "<leader>so", ":lua require('harpoon.ui').nav_file(9)<cr>")

        -- Terminals
        c.kmap("n", "<leader>sM",
               ":lua require('harpoon.term').gotoTerminal(1)<cr>")
    end,
}
