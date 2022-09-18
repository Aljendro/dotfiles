local cmp = require('cmp')
local cmp_ultisnips = require("cmp_nvim_ultisnips.mappings")

local kind_icons = {
    Class = "ﴯ",
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
    Variable = ""
}

local lspkind_comparator = function(conf)
    local lsp_types = require('cmp.types').lsp
    return function(entry1, entry2)
        if entry1.source.name ~= 'nvim_lsp' then
            if entry2.source.name == 'nvim_lsp' then
                return false
            else
                return nil
            end
        end
        local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
        local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

        local priority1 = conf.kind_priority[kind1] or 0
        local priority2 = conf.kind_priority[kind2] or 0
        if priority1 == priority2 then return nil end
        return priority2 < priority1
    end
end

local label_comparator = function(entry1, entry2)
    return entry1.completion_item.label < entry2.completion_item.label
end

cmp.setup({
    experimental = {ghost_text = true},
    formatting = {
        format = function(entry, vim_item)
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind],
                                          vim_item.kind) -- Concatonate the icons with name of the item-kind
            vim_item.menu = ({
                nvim_lsp = '[LSP]',
                spell = '[Spellings]',
                zsh = '[Zsh]',
                buffer = '[Buffer]',
                ultisnips = '[Snip]',
                treesitter = '[Treesitter]',
                calc = '[Calculator]',
                nvim_lua = '[Lua]',
                path = '[Path]',
                nvim_lsp_signature_help = '[Signature]',
                cmdline = '[Vim Command]'
            })[entry.source.name]
            return vim_item
        end
    },
    comparators = {
        lspkind_comparator({
            kind_priority = {
                Field = 11,
                Property = 11,
                Enum = 10,
                EnumMember = 10,
                Event = 10,
                Function = 10,
                Method = 10,
                Operator = 10,
                Reference = 10,
                Struct = 10,
                Constant = 9,
                Variable = 9,
                File = 8,
                Folder = 8,
                Class = 5,
                Color = 5,
                Module = 5,
                Keyword = 2,
                Constructor = 1,
                Interface = 1,
                Snippet = 1,
                Text = 1,
                TypeParameter = 1,
                Unit = 1,
                Value = 1
            }
        }), label_comparator
    },
    snippet = {expand = function(args) vim.fn['UltiSnips#Anon'](args.body) end},
    matching = {disallow_fuzzy_matching = false},
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered()
    },
    sources = cmp.config.sources({
        {
            name = 'nvim_lsp',
            preselect = true,
            keyword_length = 2,
            group_index = 1
        },
        {
            name = 'ultisnips',
            preselect = true,
            keyword_length = 2,
            group_index = 1
        }, {
            name = 'buffer',
            preselect = true,
            keyword_length = 4,
            max_item_count = 20,
            option = {keyword_pattern = [[\k\k\k\+]]},
            group_index = 2
        }, {name = 'nvim_lsp_signature_help', group_index = 3},
        {name = 'path', group_index = 4}
    }),
    mapping = {
        ['<Tab>'] = cmp.mapping(function(fallback)
            cmp_ultisnips.compose {"expand", "jump_forwards"}(fallback)
        end, {'i', 's'}),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            cmp_ultisnips.compose {"jump_backwards"}(fallback)
        end, {'i', 's'}),
        ['<M-j>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i'}),
        ['<M-k>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i'}),
        ['<C-j>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
            else
                fallback()
            end
        end, {'i', 'c'}),
        ['<C-k>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item({behavior = cmp.SelectBehavior.Select})
            else
                fallback()
            end
        end, {'i', 'c'}),
        ['<C-Space>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.close()
            else
                cmp.complete()
            end
        end, {'i', 'c'}),
        ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({select = true})
            else
                fallback()
            end
        end, {'i', 'c'})
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        {name = 'path', keyword_length = 3, group_index = 1},
        {name = 'cmdline', keyword_length = 3, group_index = 2}
    })
})

