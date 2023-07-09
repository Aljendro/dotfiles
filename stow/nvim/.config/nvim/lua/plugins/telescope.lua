return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
        { ";/", ":lua require('telescope.builtin').search_history()<cr>" },
        {
            ";;",
            ":lua require('telescope.builtin').command_history()<cr>",
            mode = { "n", "x" },
        },
        { ";a", ":lua require('telescope.builtin').autocommands()<cr>" },
        { ";b",
          ":lua require('telescope.builtin').buffers({sort_mru=true})<cr>" },
        { ";B", ":lua require('telescope.builtin').builtin()<cr>" },
        { ";c", ":lua require('telescope.builtin').commands()<cr>" },
        {
            ";f",
            ":lua require('telescope.builtin').find_files({hidden=true})<cr>",
        },
        { ";gc", ":lua require('telescope.builtin').git_bcommits()<cr>" },
        { ";gC", ":lua require('telescope.builtin').git_commits()<cr>" },
        { ";gb", ":lua require('telescope.builtin').git_branches()<cr>" },
        { ";gf", ":lua require('telescope.builtin').git_files()<cr>" },
        { ";gg", ":lua require('telescope.builtin').live_grep()<cr>" },
        { ";gr", ":Telescope grep_string search=" },
        { ";gs", ":lua require('telescope.builtin').git_stash()<cr>" },
        { ";h", ":lua require('telescope.builtin').help_tags()<cr>" },
        {
            ";j",
            ":lua require('telescope.builtin').jumplist({ignore_filename=false})<cr>",
        },
        { ";k", ":lua require('telescope.builtin').keymaps()<cr>" },
        { ";ll", ":lua require('telescope.builtin').loclist()<cr>" },
        { ";ld", ":lua require('telescope.builtin').diagnostics({bufnr=0})<cr>" },
        { ";lD", ":lua require('telescope.builtin').diagnostics()<cr>" },
        { ";lm", ":lua require('telescope.builtin').man_pages()<cr>" },
        { ";ls", ":lua require('telescope.builtin').lsp_document_symbols()<cr>" },
        {
            ";lS",
            ":lua require('telescope.builtin').lsp_workspace_symbols({query=''})<left><left><left>",
        },
        { ";m", ":lua require('telescope.builtin').marks()<cr>" },
        { ";n", ":lua require('telescope').extensions.neoclip.default()<cr>" },
        { ";of", ":lua require('telescope.builtin').oldfiles()<cr>" },
        { ";p", ":lua require('telescope.builtin').pickers()<cr>" },
        { ";q", ":lua require('telescope.builtin').quickfix()<cr>" },
        { ";r", ":lua require('telescope.builtin').resume()<cr>" },
        { ";R", ":lua require('telescope.builtin').registers()<cr>" },
        {
            ";s",
            ":lua require('telescope.builtin').current_buffer_fuzzy_find({skip_empty_lines=true})<cr>",
        },
        { ";t", ":lua require('telescope.builtin').treesitter()<cr>" },
        { ";vf", ":lua require('telescope.builtin').filetypes()<cr>" },
        { ";vo", ":lua require('telescope.builtin').vim_options()<cr>" },
        { ";w", ":Telescope grep_string<cr>" },
        {
            ";w",
            ":call v:lua.GetSelectedTextGrep()<cr>:Telescope grep_string additional_args={'-F'} search=<C-R>=@/<cr><cr>",
            mode = "x",
        },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        {
            "AckslD/nvim-neoclip.lua",
            config = function()
                require("neoclip").setup(
                    { default_register = { "\"", "+", "*" } })
            end,
        },
    },
    config = function()
        local c = require("common")
        local telescope_actions = require("telescope.actions")
        local telescope = require("telescope")
        telescope.setup {
            defaults = {
                mappings = {
                    i = {
                        ["<C-j>"] = telescope_actions.move_selection_next,
                        ["<C-k>"] = telescope_actions.move_selection_previous,
                    },
                    n = {
                        ["<C-j>"] = telescope_actions.move_selection_next,
                        ["<C-k>"] = telescope_actions.move_selection_previous,
                    },
                },
                cache_picker = { num_pickers = 20 },
                layout_strategy = "flex",
                layout_config = {
                    height = 0.95,
                    width = 0.95,
                    horizontal = { preview_width = 0.5 },
                    vertical = { preview_height = 0.45 },
                },
            },
        }
        telescope.load_extension("fzf")
    end,
};