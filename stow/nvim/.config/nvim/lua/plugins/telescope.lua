return {
    "nvim-telescope/telescope.nvim",
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

        c.kmap("n", ";/",
               ":lua require('telescope.builtin').search_history()<cr>")
        c.kmap("n", ";;",
               ":lua require('telescope.builtin').command_history()<cr>")
        c.kmap("x", ";;",
               ":lua require('telescope.builtin').command_history()<cr>")
        c.kmap("n", ";a", ":lua require('telescope.builtin').autocommands()<cr>")
        c.kmap("n", ";b",
               ":lua require('telescope.builtin').buffers({sort_mru=true})<cr>")
        c.kmap("n", ";B", ":lua require('telescope.builtin').builtin()<cr>")
        c.kmap("n", ";c", ":lua require('telescope.builtin').commands()<cr>")
        c.kmap("n", ";f",
               ":lua require('telescope.builtin').find_files({hidden=true})<cr>")
        c.kmap("n", ";gc",
               ":lua require('telescope.builtin').git_bcommits()<cr>")
        c.kmap("n", ";gC", ":lua require('telescope.builtin').git_commits()<cr>")
        c.kmap("n", ";gb",
               ":lua require('telescope.builtin').git_branches()<cr>")
        c.kmap("n", ";gf", ":lua require('telescope.builtin').git_files()<cr>")
        c.kmap("n", ";gg", ":lua require('telescope.builtin').live_grep()<cr>")
        c.kmap("n", ";gr", ":Telescope grep_string search=")
        c.kmap("n", ";gs", ":lua require('telescope.builtin').git_stash()<cr>")
        c.kmap("n", ";h", ":lua require('telescope.builtin').help_tags()<cr>")
        c.kmap("n", ";j",
               ":lua require('telescope.builtin').jumplist({ignore_filename=false})<cr>")
        c.kmap("n", ";k", ":lua require('telescope.builtin').keymaps()<cr>")
        c.kmap("n", ";ll", ":lua require('telescope.builtin').loclist()<cr>")
        c.kmap("n", ";ld",
               ":lua require('telescope.builtin').diagnostics({bufnr=0})<cr>")
        c.kmap("n", ";lD", ":lua require('telescope.builtin').diagnostics()<cr>")
        c.kmap("n", ";lm", ":lua require('telescope.builtin').man_pages()<cr>")
        c.kmap("n", ";ls",
               ":lua require('telescope.builtin').lsp_document_symbols()<cr>")
        c.kmap("n", ";lS",
               ":lua require('telescope.builtin').lsp_workspace_symbols({query=''})<left><left><left>")
        c.kmap("n", ";m", ":lua require('telescope.builtin').marks()<cr>")
        c.kmap("n", ";n",
               ":lua require('telescope').extensions.neoclip.default()<cr>")
        c.kmap("n", ";of", ":lua require('telescope.builtin').oldfiles()<cr>")
        c.kmap("n", ";p", ":lua require('telescope.builtin').pickers()<cr>")
        c.kmap("n", ";q", ":lua require('telescope.builtin').quickfix()<cr>")
        c.kmap("n", ";r", ":lua require('telescope.builtin').resume()<cr>")
        c.kmap("n", ";R", ":lua require('telescope.builtin').registers()<cr>")
        c.kmap("n", ";s",
               ":lua require('telescope.builtin').current_buffer_fuzzy_find({skip_empty_lines=true})<cr>")
        c.kmap("n", ";t", ":lua require('telescope.builtin').treesitter()<cr>")
        c.kmap("n", ";vf", ":lua require('telescope.builtin').filetypes()<cr>")
        c.kmap("n", ";vo", ":lua require('telescope.builtin').vim_options()<cr>")
        c.kmap("n", ";w", ":Telescope grep_string<cr>")
        c.kmap("x", ";w",
               ":call v:lua.GetSelectedTextGrep()<cr>:Telescope grep_string additional_args={'-F'} search=<C-R>=@/<cr><cr>")
    end,
};
