local cmp = require('cmp')
local helper = require('aljendro/config/helper')

cmp.setup({
    experimental = {native_menu = false, ghost_text = true},
    formatting = {
        format = require("lspkind").cmp_format({
            with_text = true,
            menu = ({
                nvim_lsp = "[LSP]",
                buffer = "[Buffer]",
                ultisnips = "[Ulti]",
                dictionary = "[Dict]"
            })
        })
    },
    snippet = {expand = function(args) vim.fn["UltiSnips#Anon"](args.body) end},
    sources = {
        {name = 'ultisnips', preselect = true},
        {name = 'nvim_lsp', preselect = true}, {
            name = 'buffer',
            preselect = true,
            max_item_count = 20,
            options = {keyword_pattern = [[\k\k\k\k\+]]}
        }, {name = 'path'}
    },
    mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-u>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.close(),
        ['<cr>'] = cmp.mapping.confirm({select = true}),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if vim.fn.complete_info()["selected"] == -1 and
                vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
                vim.fn.feedkeys(t("<C-R>=UltiSnips#ExpandSnippet()<cr>"))
            elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                vim.fn.feedkeys(t("<ESC>:call UltiSnips#JumpForwards()<cr>"))
            elseif vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(t("<C-n>"), "n")
            elseif helpers.check_back_space() then
                vim.fn.feedkeys(t("<tab>"), "n")
            else
                fallback()
            end
        end, {"i", "s"}),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                return vim.fn.feedkeys(t("<C-R>=UltiSnips#JumpBackwards()<cr>"))
            elseif vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(t("<C-p>"), "n")
            else
                fallback()
            end
        end, {"i", "s"})
    }
})

