require('plugins')

vim.cmd("source ~/.vimrc")

local cmp = require'cmp'
local nvim_lsp = require('lspconfig')

local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
        local col = vim.fn.col(".") - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        -- Mappings.
        local opts = { noremap=true, silent=true }

        -- See `:help vim.lsp.*` for documentation on any of the below functions

        -- TODO: Implement tab and vsplit
        -- nnoremap <silent> gt :call CocActionAsync('jumpDefinition', 'tabe')<cr>
        -- nnoremap <silent> gv :call CocActionAsync('jumpDefinition', 'vsplit')<cr>
        buf_set_keymap('n','gD'        ,'<cmd>lua vim.lsp.buf.declaration()<CR>'                               ,opts)
        buf_set_keymap('n','gd'        ,'<cmd>lua vim.lsp.buf.definition()<CR>'                                ,opts)
        buf_set_keymap('n','gk'        ,'<cmd>lua vim.lsp.buf.hover()<CR>'                                     ,opts)
        buf_set_keymap('n','gi'        ,'<cmd>lua vim.lsp.buf.implementation()<CR>'                            ,opts)
        buf_set_keymap('n','gK'        ,'<cmd>lua vim.lsp.buf.signature_help()<CR>'                            ,opts)
        buf_set_keymap('n','<leader>la','<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>'                      ,opts)
        buf_set_keymap('n','<leader>lr','<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>'                   ,opts)
        buf_set_keymap('n','<leader>lw','<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',opts)
        buf_set_keymap('n','gT'        ,'<cmd>lua vim.lsp.buf.type_definition()<CR>'                           ,opts)
        buf_set_keymap('n','<leader>rn','<cmd>lua vim.lsp.buf.rename()<CR>'                                    ,opts)
        buf_set_keymap('n','<leader>ca','<cmd>lua vim.lsp.buf.code_action()<CR>'                               ,opts)
        buf_set_keymap('n','gr'        ,'<cmd>lua vim.lsp.buf.references()<CR>'                                ,opts)
        buf_set_keymap('n','ge'        ,'<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>'              ,opts)
        buf_set_keymap('n','[g'        ,'<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>'                          ,opts)
        buf_set_keymap('n',']g'        ,'<cmd>lua vim.lsp.diagnostic.goto_next()<CR>'                          ,opts)
        buf_set_keymap('n','<leader>lq','<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>'                        ,opts)
        buf_set_keymap('n','<leader>lf','<cmd>lua vim.lsp.buf.formatting()<CR>'                                ,opts)

end

cmp.setup({
        snippet = {
                expand = function(args)
                        vim.fn["UltiSnips#Anon"](args.body)
                end,
        },
        sources = {
                { name = 'nvim_lsp' },
                { name = 'ultisnips' },
                { name = 'buffer' },
        },
        mapping = {
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping(function(fallback)
                        if vim.fn.pumvisible() == 1 then
                                if vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
                                        return vim.fn.feedkeys(t("<C-R>=UltiSnips#ExpandSnippet()<CR>"))
                                end
                                vim.fn.feedkeys(t("<C-n>"), "n")
                        elseif check_back_space() then
                                vim.fn.feedkeys(t("<cr>"), "n")
                        else
                                fallback()
                        end
                end, {
                                "i",
                                "s",
                        }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                        if vim.fn.complete_info()["selected"] == -1 and vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
                                vim.fn.feedkeys(t("<C-R>=UltiSnips#ExpandSnippet()<CR>"))
                        elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                                vim.fn.feedkeys(t("<ESC>:call UltiSnips#JumpForwards()<CR>"))
                        elseif vim.fn.pumvisible() == 1 then
                                vim.fn.feedkeys(t("<C-n>"), "n")
                        elseif check_back_space() then
                                vim.fn.feedkeys(t("<tab>"), "n")
                        else
                                fallback()
                        end
                end, {
                                "i",
                                "s",
                        }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                                return vim.fn.feedkeys(t("<C-R>=UltiSnips#JumpBackwards()<CR>"))
                        elseif vim.fn.pumvisible() == 1 then
                                vim.fn.feedkeys(t("<C-p>"), "n")
                        else
                                fallback()
                        end
                end, {
                                "i",
                                "s",
                        }),
        },
})

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'tsserver' }
for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
                capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
                on_attach = on_attach,
                handlers = {
                        ["textDocument/publishDiagnostics"] = vim.lsp.with(
                                vim.lsp.diagnostic.on_publish_diagnostics, {
                                        -- Disable virtual_text
                                        virtual_text = false
                                }
                        ),
                },
                flags = {
                        debounce_text_changes = 150,
                }
        }
end

require('telescope').load_extension('fzf')
require('gitsigns').setup()
require('nvim-treesitter.configs').setup({
        ensure_installed = 'all',
        highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
                enable = false,
                keymaps = {
                        init_selection = "gnn",
                        node_decremental = "grm",
                        node_incremental = "grn",
                        scope_incremental = "grc"
                },
        },
        indent = {
                enable = true,
        }
})
