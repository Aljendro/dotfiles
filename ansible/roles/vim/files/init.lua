require('plugins')

vim.cmd("source ~/.vimrc")

local cmp = require('cmp')
local nvim_lsp = require('lspconfig')
local dap = require('dap')

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
        buf_set_keymap('n','gD'        ,'<cmd>lua vim.lsp.buf.declaration()<cr>'                               ,opts)
        buf_set_keymap('n','gK'        ,'<cmd>lua vim.lsp.buf.signature_help()<cr>'                            ,opts)
        buf_set_keymap('n','gR'        ,'<cmd>lua vim.lsp.buf.rename()<cr>'                                    ,opts)
        buf_set_keymap('n','gT'        ,'<cmd>lua vim.lsp.buf.type_definition()<cr>'                           ,opts)
        buf_set_keymap('n','ga'        ,'<cmd>lua vim.lsp.buf.code_action()<cr>'                               ,opts)
        buf_set_keymap('n','gd'        ,'<cmd>lua vim.lsp.buf.definition()<cr>'                                ,opts)
        buf_set_keymap('n','gi'        ,'<cmd>lua vim.lsp.buf.implementation()<cr>'                            ,opts)
        buf_set_keymap('n','gk'        ,'<cmd>lua vim.lsp.buf.hover()<cr>'                                     ,opts)
        buf_set_keymap('n','gr'        ,'<cmd>lua vim.lsp.buf.references()<cr>'                                ,opts)
        buf_set_keymap('n','gv'        ,'<cmd>vsplit<cr><cmd>lua vim.lsp.buf.definition()<cr>'                 ,opts)
        buf_set_keymap('n','gt'        ,'<cmd>tab split<cr><cmd>lua vim.lsp.buf.definition()<cr>'              ,opts)
        buf_set_keymap('n','[g'        ,'<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>'                          ,opts)
        buf_set_keymap('n',']g'        ,'<cmd>lua vim.lsp.diagnostic.goto_next()<cr>'                          ,opts)
        buf_set_keymap('n','gla'       ,'<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>'                      ,opts)
        buf_set_keymap('n','gld'       ,'<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>'              ,opts)
        buf_set_keymap('n','glf'       ,'<cmd>lua vim.lsp.buf.formatting()<cr>'                                ,opts)
        buf_set_keymap('n','glq'       ,'<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>'                        ,opts)
        buf_set_keymap('n','glr'       ,'<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>'                   ,opts)
        buf_set_keymap('n','glw'       ,'<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>',opts)

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
                ['<cr>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<Tab>"] = cmp.mapping(function(fallback)
                        if vim.fn.complete_info()["selected"] == -1 and vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
                                vim.fn.feedkeys(t("<C-R>=UltiSnips#ExpandSnippet()<cr>"))
                        elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                                vim.fn.feedkeys(t("<ESC>:call UltiSnips#JumpForwards()<cr>"))
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
                                return vim.fn.feedkeys(t("<C-R>=UltiSnips#JumpBackwards()<cr>"))
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

dap.adapters.node2 = {
        type = 'executable',
        command = 'node',
        args = {os.getenv('HOME') .. '/.local/share/nvim/dapinstall/jsnode/vscode-node-debug2/out/src/nodeDebug.js'}
}

vim.fn.sign_define('DapBreakpoint', {text='🟩', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapCondition', {text='🟧', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='🟥', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='➡️', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text='📓', texthl='', linehl='', numhl=''})

require('telescope').load_extension('fzf')
require('telescope').load_extension('dap')
require('gitsigns').setup()
require('hop').setup()
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