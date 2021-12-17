local helper = require('aljendro/config/helper')

local opts = {noremap = true, silent = true}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    helper.buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    helper.buf_set_keymap('n', 'gK', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    helper.buf_set_keymap('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    helper.buf_set_keymap('n', 'gT', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    helper.buf_set_keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    helper.buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    helper.buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    helper.buf_set_keymap('n', 'gk', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    helper.buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    helper.buf_set_keymap('n', 'glf', '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)
    helper.buf_set_keymap('v', 'glf', '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)
    helper.buf_set_keymap('n', 'gv',
                   '<cmd>vsplit<cr><cmd>lua vim.lsp.buf.definition()<cr>', opts)
    helper.buf_set_keymap('n', 'gt',
                   '<cmd>tab split<cr><cmd>lua vim.lsp.buf.definition()<cr>',
                   opts)
    helper.buf_set_keymap('n', '[g', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>',
                   opts)
    helper.buf_set_keymap('n', ']g', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>',
                   opts)
    helper.buf_set_keymap('n', 'gla',
                   '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>', opts)
    helper.buf_set_keymap('n', 'gld',
                   '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>',
                   opts)
    helper.buf_set_keymap('n', 'glq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>',
                   opts)
    helper.buf_set_keymap('n', 'glr',
                   '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>', opts)
    helper.buf_set_keymap('n', 'glw',
                   '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>',
                   opts)

end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp
                                                                     .protocol
                                                                     .make_client_capabilities())

--------------------------------------------------
------------------- Javascript -------------------
--------------------------------------------------

lspconfig.tsserver.setup({
    cmd = {helper.lsp_dir .. "/tsserver/node_modules/.bin/tsserver", "--stdio"},
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {debounce_text_changes = 150}
})

--------------------------------------------------
--------------------- HTML -----------------------
--------------------------------------------------

lspconfig.html.setup({
    cmd = {
        helper.lsp_dir ..
            "/html/node_modules/vscode-langservers-extracted/bin/vscode-html-language-server",
        "--stdio"
    },
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {debounce_text_changes = 150}
})

--------------------------------------------------
--------------------- CSS ------------------------
--------------------------------------------------

lspconfig.cssls.setup({
    cmd = {
        helper.lsp_dir ..
            "/cssls/node_modules/vscode-langservers-extracted/bin/vscode-css-language-server",
        "--stdio"
    },
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {debounce_text_changes = 150}
})

--------------------------------------------------
-------------------- JSON ------------------------
--------------------------------------------------

lspconfig.jsonls.setup({
    cmd = {
        helper.lsp_dir ..
            "/jsonls/node_modules/vscode-langservers-extracted/bin/vscode-json-language-server",
        "--stdio"
    },
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {debounce_text_changes = 150}
})

--------------------------------------------------
------------------- Clojure ----------------------
--------------------------------------------------

lspconfig.clojure_lsp.setup({
    cmd = {helper.lsp_dir .. "/clojure_lsp/clojure-lsp"},
    capabilities = capabilities,
    on_attach = on_attach
})

--------------------------------------------------
--------------------- EFM ------------------------
--------------------------------------------------

local prettier = {
    formatCommand = "prettier --stdin-filepath ${INPUT}",
    formatStdin = true
}

local eslint = {
    lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = {"%f:%l:%c: %m"}
}

lspconfig.efm.setup({
    cmd = {helper.lsp_dir .. "/efm/efm-langserver"},
    on_attach = function(client, bufn)
        helper.buf_set_keymap('n', 'gef', '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)
        helper.buf_set_keymap('v', 'gef', '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)
    end,
    init_options = {documentFormatting = true},
    filetypes = {
        "lua", "javascript", "javascriptreact", "typescript",
        "typescriptreact"
    },
    settings = {
        rootMarkers = lspconfig.util.root_pattern(".git"),
        languages = {
            lua = {{formatCommand = "lua-format -i", formatStdin = true}},
            javascript = {prettier, eslint},
            javascriptreact = {prettier, eslint},
            typescript = {prettier, eslint},
            typescriptreact = {prettier, eslint}
        }
    }
})
