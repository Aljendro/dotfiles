return {
    "l3mon4d3/luasnip",
    version = "v1.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
        local ls = require("luasnip")
        ls.config.set_config({
            enable_autosnippets = true,
            history = true,
            update_events = "TextChanged,TextChangedI",
            store_selection_keys = "<tab>",
        })
        require("luasnip.loaders.from_snipmate").load({
            path = { os.getenv("HOME") .. "/.config/nvim/snippets" },
        })
        require("luasnip.loaders.from_lua").load({
            paths = os.getenv("HOME") .. "/.config/nvim/snippets",
        })
        vim.api.nvim_create_user_command("LuaSnipEdit", function()
            require("luasnip.loaders").edit_snippet_files({
                edit = function(fileName)
                    vim.cmd("vsplit " .. fileName)
                end,
            })
        end, {})
    end,
};
