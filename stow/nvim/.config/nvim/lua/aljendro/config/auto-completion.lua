local cmp = require('cmp')
local helper = require('aljendro/config/helper')

cmp.setup({
    experimental = {native_menu = false, ghost_text = true},
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
            options = {keyword_pattern = [[\k\k\k\k\+]]}
        }, {name = 'path'}
    }),
    mapping = {
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
        ['<C-k>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close()
        }),
        ['<C-j>'] = cmp.mapping.confirm({select = true}),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if vim.fn.complete_info()['selected'] == -1 and
                vim.fn['UltiSnips#CanExpandSnippet']() == 1 then
                vim.fn.feedkeys(helper.t('<C-R>=UltiSnips#ExpandSnippet()<cr>'))
            elseif vim.fn['UltiSnips#CanJumpForwards']() == 1 then
                vim.fn.feedkeys(helper.t(
                                    '<ESC>:call UltiSnips#JumpForwards()<cr>'))
            elseif vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(helper.t('<C-n>'), 'n')
            elseif helper.check_back_space() then
                vim.fn.feedkeys(helper.t('<tab>'), 'n')
            else
                fallback()
            end
        end, {'i', 's'}),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if vim.fn['UltiSnips#CanJumpBackwards']() == 1 then
                return vim.fn.feedkeys(helper.t(
                                           '<C-R>=UltiSnips#JumpBackwards()<cr>'))
            elseif vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(helper.t('<C-p>'), 'n')
            else
                fallback()
            end
        end, {'i', 's'})
    }
})

