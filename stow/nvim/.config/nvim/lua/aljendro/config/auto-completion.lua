local cmp = require('cmp')
local cmp_ultisnips = require("cmp_nvim_ultisnips.mappings")

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
        ['<C-k>'] = cmp.mapping(cmp.mapping.close(), {'i', 'c'}),
        ['<C-j>'] = cmp.mapping.confirm({select = true}),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        ['<C-n>'] = cmp.mapping(function(fallback)
            cmp_ultisnips.expand_or_jump_forwards(fallback)
        end, {'i', 's'}),
        ['<C-p>'] = cmp.mapping(function(fallback)
            cmp_ultisnips.jump_backwards(fallback)
        end, {'i', 's'})
    }
})

