return {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.lua_format.with({
                    args = {
                        "--align-args",
                        "--align-parameter",
                        "--align-table-field",
                        "--break-after-functioncall-lp",
                        "--break-after-functiondef-lp",
                        "--break-after-table-lb",
                        "--break-before-functioncall-rp",
                        "--break-before-functiondef-rp",
                        "--break-before-table-rb",
                        "--chop-down-kv-table",
                        "--chop-down-table",
                        "--chop-down-parameter",
                        "--column-limit=120",
                        "--extra-sep-at-table-end",
                        "--no-keep-simple-function-one-line",
                        "--line-breaks-after-function-body",
                        "--single-quote-to-double-quote",
                        "--spaces-around-equals-in-field",
                        "--spaces-inside-table-braces",
                    },
                }),
                null_ls.builtins.formatting.prettier,
                null_ls.builtins.diagnostics.eslint_d,
            },
        })
    end,
}
