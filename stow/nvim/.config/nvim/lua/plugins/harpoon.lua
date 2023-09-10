return {
    "theprimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<leader>m", ":lua require('harpoon.mark').add_file()<cr>" },
        { "<leader>M", ":lua require('harpoon.ui').toggle_quick_menu()<cr>" },
        { "<leader>1", ":lua require('harpoon.ui').nav_file(1)<cr>" },
        { "<leader>2", ":lua require('harpoon.ui').nav_file(2)<cr>" },
        { "<leader>3", ":lua require('harpoon.ui').nav_file(3)<cr>" },
        { "<leader>4", ":lua require('harpoon.ui').nav_file(4)<cr>" },
        { "<leader>5", ":lua require('harpoon.ui').nav_file(5)<cr>" },
        { "<leader>6", ":lua require('harpoon.ui').nav_file(6)<cr>" },
        { "<leader>7", ":lua require('harpoon.ui').nav_file(7)<cr>" },
        { "<leader>8", ":lua require('harpoon.ui').nav_file(8)<cr>" },
        { "<leader>9", ":lua require('harpoon.ui').nav_file(9)<cr>" },
        { "<leader>0", ":lua require('harpoon.ui').nav_file(10)<cr>" },
    },
    config = function() require("harpoon").setup({ menu = { width = vim.api.nvim_win_get_width(0) - 4 } }) end,
}
