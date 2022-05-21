local lspconfig = require('lspconfig')
local helper = require('aljendro/config/helper')

local opts = {noremap = true, silent = true}

vim.diagnostic.config({virtual_text = false})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD',
                                '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gk',
                                '<cmd>lua vim.lsp.buf.signature_help()<cr>',
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gR',
                                '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gT',
                                '<cmd>lua vim.lsp.buf.type_definition()<cr>',
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ga',
                                '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'v', 'ga',
                                '<cmd>lua vim.lsp.buf.range_code_action()<cr>',
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd',
                                '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi',
                                '<cmd>lua vim.lsp.buf.implementation()<cr>',
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',
                                '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr',
                                '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'glf',
                                '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gs',
                                '<cmd>vsplit<cr><cmd>lua vim.lsp.buf.definition()<cr>',
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gt',
                                '<cmd>tab split<cr><cmd>lua vim.lsp.buf.definition()<cr>',
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gla',
                                '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>',
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'glr',
                                '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>',
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'glw',
                                '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>',
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gld',
                                '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'glq',
                                '<cmd>lua vim.diagnostic.setloclist()<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'glQ',
                                '<cmd>lua vim.diagnostic.setqflist()<cr>', opts)

    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
          " hi LspReferenceRead cterm=bold ctermbg=DarkMagenta guibg=LightYellow
          " hi LspReferenceText cterm=bold ctermbg=DarkMagenta guibg=LightYellow
          " hi LspReferenceWrite cterm=bold ctermbg=DarkMagenta guibg=LightYellow
          augroup lsp_document_highlight
            autocmd! * <buffer>
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
          augroup END
        ]], false)
    end
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp
                                                                     .protocol
                                                                     .make_client_capabilities())

--------------------------------------------------
-------------------- Rust ------------------------
--------------------------------------------------

lspconfig.rust_analyzer.setup({
    cmd = {helper.lsp_dir .. '/rust/rust-analyzer'},
    capabilities = capabilities,
    on_attach = on_attach
})

--------------------------------------------------
------------------- Docker -----------------------
--------------------------------------------------

lspconfig.dockerls.setup({
    cmd = {
        helper.lsp_dir .. '/dockerfile/node_modules/.bin/docker-langserver',
        '--stdio'
    },
    capabilities = capabilities
})

--------------------------------------------------
------------------- Clojure ----------------------
--------------------------------------------------

lspconfig.clojure_lsp
    .setup({capabilities = capabilities, on_attach = on_attach})

--------------------------------------------------
--------------------- Go -------------------------
--------------------------------------------------

lspconfig.gopls.setup({
    cmd = {helper.lsp_dir .. '/go/gopls'},
    capabilities = capabilities,
    on_attach = on_attach
})

--------------------------------------------------
------------------- Python -----------------------
--------------------------------------------------

lspconfig.pyright.setup({
    cmd = {
        helper.lsp_dir .. '/python/node_modules/.bin/pyright-langserver',
        '--stdio'
    },
    capabilities = capabilities,
    on_attach = on_attach
})

--------------------------------------------------
------------ Javascript/Typescript ---------------
--------------------------------------------------

lspconfig.tsserver.setup({
    cmd = {
        helper.lsp_dir ..
            '/tsserver/node_modules/.bin/typescript-language-server', '--stdio'
    },
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        client.resolved_capabilities.document_formatting = false
        on_attach(client, bufnr)
    end,
    flags = {debounce_text_changes = 150}
})

--------------------------------------------------
--------------------- HTML -----------------------
--------------------------------------------------

lspconfig.html.setup({
    cmd = {
        helper.lsp_dir ..
            '/html/node_modules/vscode-langservers-extracted/bin/vscode-html-language-server',
        '--stdio'
    },
    capabilities = capabilities
})

--------------------------------------------------
--------------------- CSS ------------------------
--------------------------------------------------

lspconfig.cssls.setup({
    cmd = {
        helper.lsp_dir ..
            '/cssls/node_modules/vscode-langservers-extracted/bin/vscode-css-language-server',
        '--stdio'
    },
    capabilities = capabilities
})

--------------------------------------------------
-------------------- JSON ------------------------
--------------------------------------------------

local schemas = {
    {
        description = 'TypeScript compiler configuration file',
        fileMatch = {'tsconfig.json', 'tsconfig.*.json'},
        url = 'https://json.schemastore.org/tsconfig.json'
    }, {
        description = 'Lerna config',
        fileMatch = {'lerna.json'},
        url = 'https://json.schemastore.org/lerna.json'
    }, {
        description = 'Babel configuration',
        fileMatch = {'.babelrc.json', '.babelrc', 'babel.config.json'},
        url = 'https://json.schemastore.org/babelrc.json'
    }, {
        description = 'ESLint config',
        fileMatch = {'.eslintrc.json', '.eslintrc'},
        url = 'https://json.schemastore.org/eslintrc.json'
    }, {
        description = 'Prettier config',
        fileMatch = {'.prettierrc', '.prettierrc.json', 'prettier.config.json'},
        url = 'https://json.schemastore.org/prettierrc'
    }, {
        description = 'AWS CloudFormation provides a common language for you to describe and provision all the infrastructure resources in your cloud environment.',
        fileMatch = {'*.cf.json', 'cloudformation.json'},
        url = 'https://raw.githubusercontent.com/awslabs/goformation/v5.2.9/schema/cloudformation.schema.json'
    }, {
        description = 'The AWS Serverless Application Model (AWS SAM, previously known as Project Flourish) extends AWS CloudFormation to provide a simplified way of defining the Amazon API Gateway APIs, AWS Lambda functions, and Amazon DynamoDB tables needed by your serverless application.',
        fileMatch = {'serverless.template', '*.sam.json', 'sam.json'},
        url = 'https://raw.githubusercontent.com/awslabs/goformation/v5.2.9/schema/sam.schema.json'
    }, {
        description = 'NPM configuration file',
        fileMatch = {'package.json'},
        url = 'https://json.schemastore.org/package.json'
    }
}

lspconfig.jsonls.setup({
    cmd = {
        helper.lsp_dir ..
            '/jsonls/node_modules/vscode-langservers-extracted/bin/vscode-json-language-server',
        '--stdio'
    },
    capabilities = capabilities,
    settings = {json = {schemas = schemas}}
})

--------------------------------------------------
--------------------- Lua ------------------------
--------------------------------------------------

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')
require('lspconfig').sumneko_lua.setup({
    on_attach = function(client, bufnr)
        client.resolved_capabilities.document_formatting = false
        on_attach(client, bufnr)
    end,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim', 'use'}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file('', true)
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {enable = false}
        }
    }
})

--------------------------------------------------
--------------------- EFM ------------------------
--------------------------------------------------

local prettier = {
    formatCommand = 'prettier --stdin-filepath ${INPUT}',
    formatStdin = true
}

local eslint = {
    lintCommand = 'eslint_d -f unix --stdin --stdin-filename ${INPUT}',
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = {'%f:%l:%c: %m'}
}

lspconfig.efm.setup({
    cmd = {helper.lsp_dir .. '/efm/efm-langserver'},
    init_options = {documentFormatting = true},
    filetypes = {
        'lua', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact'
    },
    settings = {
        rootMarkers = {'.git/'},
        languages = {
            lua = {{formatCommand = 'lua-format -i', formatStdin = true}},
            javascript = {prettier, eslint},
            javascriptreact = {prettier, eslint},
            typescript = {prettier, eslint},
            typescriptreact = {prettier, eslint}
        }
    }
})
