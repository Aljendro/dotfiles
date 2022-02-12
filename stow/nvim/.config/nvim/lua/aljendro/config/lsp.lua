local lspconfig = require('lspconfig')
local helper = require('aljendro/config/helper')

local opts = {noremap = true, silent = true}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client)

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    helper.buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>',
                          opts)
    helper.buf_set_keymap('n', 'gK',
                          '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    helper.buf_set_keymap('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    helper.buf_set_keymap('n', 'gT',
                          '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    helper.buf_set_keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<cr>',
                          opts)
    helper.buf_set_keymap('v', 'ga',
                          '<cmd>lua vim.lsp.buf.range_code_action()<cr>', opts)
    helper.buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>',
                          opts)
    helper.buf_set_keymap('n', 'gi',
                          '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    helper.buf_set_keymap('n', 'gk', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    helper.buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>',
                          opts)
    helper.buf_set_keymap('n', 'glf', '<cmd>lua vim.lsp.buf.formatting()<cr>',
                          opts)
    helper.buf_set_keymap('n', 'gs',
                          '<cmd>vsplit<cr><cmd>lua vim.lsp.buf.definition()<cr>',
                          opts)
    helper.buf_set_keymap('n', 'gt',
                          '<cmd>tab split<cr><cmd>lua vim.lsp.buf.definition()<cr>',
                          opts)
    helper.buf_set_keymap('n', 'gla',
                          '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>',
                          opts)
    helper.buf_set_keymap('n', 'glr',
                          '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>',
                          opts)
    helper.buf_set_keymap('n', 'glw',
                          '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>',
                          opts)
    helper.buf_set_keymap('n', 'gld',
                          '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
    helper.buf_set_keymap('n', 'glq',
                          '<cmd>lua vim.diagnostic.setloclist()<cr>', opts)
    helper.buf_set_keymap('n', 'glQ', '<cmd>lua vim.diagnostic.setqflist()<cr>',
                          opts)

end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp
                                                                     .protocol
                                                                     .make_client_capabilities())

--------------------------------------------------
------------------- Docker -----------------------
--------------------------------------------------

lspconfig.dockerls.setup({
    cmd = {helper.lsp_dir .. '/dockerfile/node_modules/.bin/docker-langserver', '--stdio'},
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
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        on_attach(client)
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
    on_attach = on_attach,
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
    on_attach = function()
        helper.buf_set_keymap('n', 'gef',
                              '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)
    end,
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
