return {
    "theprimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<leader>sa", ":lua require('harpoon.mark').add_file()<cr>" },
        { "<leader>sA", ":lua require('harpoon.ui').toggle_quick_menu()<cr>" },
        { "<leader>sm", ":lua require('harpoon.ui').nav_file(1)<cr>" },
        { "<leader>s,", ":lua require('harpoon.ui').nav_file(2)<cr>" },
        { "<leader>s.", ":lua require('harpoon.ui').nav_file(3)<cr>" },
        { "<leader>sj", ":lua require('harpoon.ui').nav_file(4)<cr>" },
        { "<leader>sk", ":lua require('harpoon.ui').nav_file(5)<cr>" },
        { "<leader>sl", ":lua require('harpoon.ui').nav_file(6)<cr>" },
        { "<leader>su", ":lua require('harpoon.ui').nav_file(7)<cr>" },
        { "<leader>si", ":lua require('harpoon.ui').nav_file(8)<cr>" },
        { "<leader>so", ":lua require('harpoon.ui').nav_file(9)<cr>" },
        { "<leader>sM", ":lua require('harpoon.term').gotoTerminal(1)<cr>" },
    },
    config = function()
        require("harpoon").setup({
            menu = { width = vim.api.nvim_win_get_width(0) - 4 },
        })
    end,
}
