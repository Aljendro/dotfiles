return {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
        require("chatgpt").setup({
            api_key_cmd = "bw get password d0aecf5b-d89d-4aaf-aa83-b0900148c18f",
            edit_with_instructions = {
                diff = false,
                keymaps = {
                    close = "<C-c>",
                    accept = "<C-y>",
                    toggle_diff = "<C-d>",
                    toggle_settings = "<C-o>",
                    cycle_windows = "<Tab>",
                    use_output_as_input = "<C-i>",
                },
            },
            chat = {
                welcome_message = "",
                loading_text = "Loading, please wait ...",
                keymaps = {
                    close = { "<C-c>" },
                    yank_last = "<C-y>",
                    yank_last_code = "<C-u>",
                    scroll_up = "<C-k>",
                    scroll_down = "<C-j>",
                    new_session = "<C-n>",
                    cycle_windows = "<Tab>",
                    cycle_modes = "<C-f>",
                    next_message = "<Down>",
                    prev_message = "<Up>",
                    select_session = "<Space>",
                    rename_session = "r",
                    delete_session = "d",
                    draft_message = "<C-d>",
                    edit_message = "e",
                    delete_message = "d",
                    toggle_settings = "<C-o>",
                    toggle_message_role = "<C-r>",
                    toggle_system_role_open = "<C-s>",
                    stop_generating = "<C-x>",
                },
            },
            openai_params = {
                model = "gpt-3.5-turbo-16k",
                frequency_penalty = 0,
                presence_penalty = 0,
                max_tokens = 3000,
                temperature = 0,
                top_p = 1,
                n = 1,
            },
        })

        local c = require("common")
        c.kmap("n", "<leader>cc", ":ChatGPT<cr>")

        for _, mode in ipairs({ "n", "x" }) do
            c.kmap(mode, "<leader>ce", ":ChatGPTEditWithInstruction<cr>")
            c.kmap(mode, "<leader>cg", ":ChatGPTRun grammar_correction<cr>")
            c.kmap(mode, "<leader>cT", ":ChatGPTRun translate<cr>")
            c.kmap(mode, "<leader>ck", ":ChatGPTRun keywords<cr>")
            c.kmap(mode, "<leader>cd", ":ChatGPTRun docstring<cr>")
            c.kmap(mode, "<leader>ct", ":ChatGPTRun add_tests<cr>")
            c.kmap(mode, "<leader>co", ":ChatGPTRun optimize_code<cr>")
            c.kmap(mode, "<leader>cs", ":ChatGPTRun summarize<cr>")
            c.kmap(mode, "<leader>cf", ":ChatGPTRun fix_bugs<cr>")
            c.kmap(mode, "<leader>cx", ":ChatGPTRun explain_code<cr>")
            c.kmap(mode, "<leader>cr", ":ChatGPTRun code_readability_analysis<cr>")
        end
    end,
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim"
    }
}
