local cmp = require('cmp')
local cmp_ultisnips = require("cmp_nvim_ultisnips.mappings")
local helper = require('aljendro/config/helper')

cmp.setup({
    experimental = {ghost_text = true},
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                nvim_lsp = '[LSP]',
                buffer = '[Buf]',
                ultisnips = '[Ulti]',
                dictionary = '[Dict]'
            })[entry.source.name]
            return vim_item
        end
    },
    snippet = {expand = function(args) vim.fn['UltiSnips#Anon'](args.body) end},
    sources = cmp.config.sources({
        {name = 'nvim_lsp', preselect = true},
        {name = 'ultisnips', preselect = true}, {
            name = 'buffer',
            preselect = true,
            max_item_count = 20,
            option = {keyword_pattern = [[\k\k\k\+]]}
        }, {name = 'path'}
    }),
    mapping = {
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
        ['<C-e>'] = cmp.mapping(cmp.mapping.close(), {'i'}),
        ['<Tab>'] = cmp.mapping(function(fallback)
            cmp_ultisnips.expand_or_jump_forwards(fallback)
        end, {'i', 's'}),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            cmp_ultisnips.jump_backwards(fallback)
        end, {'i', 's'}),
        ['<C-n>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
            else
                fallback()
            end
        end, {'i'}),
        ['<C-p>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item({behavior = cmp.SelectBehavior.Select})
            else
                fallback()
            end
        end, {'i'}),
        ['<C-Space>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true
                })
            else
                cmp.mapping.complete()
            end
        end, {'i'})
    }
})

