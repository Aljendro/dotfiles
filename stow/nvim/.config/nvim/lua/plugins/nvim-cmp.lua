return {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter" },
    dependencies = {
        { "david-kunz/cmp-npm", dependencies = { "nvim-lua/plenary.nvim" } },
        "l3mon4d3/luasnip",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-path",
        "saadparwaiz1/cmp_luasnip",
    },
    config = function()
        local kind_icons = {
            Class = "C",
            Color = "",
            Constant = "",
            Constructor = "",
            Enum = "",
            EnumMember = "",
            Event = "",
            Field = "",
            File = "",
            Folder = "",
            Function = "",
            Interface = "",
            Keyword = "",
            Method = "",
            Module = "",
            Operator = "",
            Property = "ﰠ",
            Reference = "",
            Snippet = "",
            Struct = "",
            Text = "",
            TypeParameter = "",
            Unit = "",
            Value = "",
            Variable = "",
        }

        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local cmp_npm = require("cmp-npm")

        cmp_npm.setup({})
        cmp.setup({
            experimental = { ghost_text = false },
            formatting = {
                format = function(_, vim_item)
                    vim_item.kind = string.format("%s %s",
                                                  kind_icons[vim_item.kind],
                                                  vim_item.kind)
                    vim_item.menu = ""
                    return vim_item
                end,
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            matching = { disallow_fuzzy_matching = false },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            sources = cmp.config.sources({
                { name = "npm", preselect = true, keyword_length = 4 },
                {
                    name = "nvim_lsp",
                    preselect = true,
                    keyword_length = 2,
                    group_index = 1,
                },
                {
                    name = "luasnip",
                    preselect = true,
                    keyword_length = 2,
                    group_index = 2,
                },
                {
                    name = "buffer",
                    preselect = true,
                    keyword_length = 4,
                    max_item_count = 20,
                    option = { keyword_pattern = "\\k\\k\\k\\+" },
                    group_index = 3,
                },
                { name = "nvim_lsp_signature_help", group_index = 4 },
                { name = "path", group_index = 5 },
            }),
            mapping = {
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i" }),
                ["<M-j>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i" }),
                ["<M-k>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i" }),
                ["<C-j>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item({
                            behavior = cmp.SelectBehavior.Select,
                        })
                    elseif luasnip.choice_active() then
                        luasnip.change_choice(1)
                    else
                        fallback()
                    end
                end, { "i", "s", "c" }),
                ["<C-k>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item({
                            behavior = cmp.SelectBehavior.Select,
                        })
                    elseif luasnip.choice_active() then
                        luasnip.change_choice(-1)
                    else
                        fallback()
                    end
                end, { "i", "s", "c" }),
                ["<C-Space>"] = cmp.mapping(function(_)
                    if cmp.visible() then
                        cmp.close()
                    else
                        cmp.complete()
                    end
                end, { "i", "c" }),
                ["<CR>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.confirm({ select = true })
                    else
                        fallback()
                    end
                end, { "i", "c" }),
            },
        })
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            completion = { autocomplete = false },
            sources = cmp.config.sources({
                { name = "path", keyword_length = 3, group_index = 1 },
                { name = "cmdline", keyword_length = 3, group_index = 2 },
                { name = "buffer", keyword_length = 3, group_index = 3 },
            }),
        })
    end,
}
