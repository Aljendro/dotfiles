local function require_lsp()
    local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
    local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local requires_ok = lspconfig_ok and cmp_nvim_lsp_ok

    if not requires_ok then
        return { false }
    else
        local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
        return { true, lspconfig, capabilities }
    end
end

-- Use an on_attach to only map the following keys
-- after the language server attaches to the current buffer
local function on_attach(_, bufnr)
    local c = require("common")
    local opts = { silent = true }
    -- Set keymaps for LSP functionality
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    c.kbmap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    c.kbmap(bufnr, "n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
    c.kbmap(bufnr, "n", "gR", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    c.kbmap(bufnr, "n", "gT", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
    c.kbmap(bufnr, "n", "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    c.kbmap(bufnr, "x", "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    c.kbmap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    c.kbmap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    c.kbmap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
    c.kbmap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
    c.kbmap(bufnr, "n", "glf", "<cmd>lua vim.lsp.buf.format({ async = false })<cr>", opts)
    c.kbmap(bufnr, "x", "glf", "<cmd>lua vim.lsp.buf.format({ async = false })<cr>", opts)
    c.kbmap(bufnr, "n", "gs", "<cmd>vsplit<cr><cmd>lua vim.lsp.buf.definition()<cr>", opts)
    c.kbmap(bufnr, "n", "gt", "<cmd>tab split<cr><cmd>lua vim.lsp.buf.definition()<cr>", opts)
    c.kbmap(bufnr, "n", "gla", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", opts)
    c.kbmap(bufnr, "n", "glr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", opts)
    c.kbmap(bufnr, "n", "glw", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", opts)
    c.kbmap(bufnr, "n", "gld", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
    c.kbmap(bufnr, "n", "glq", "<cmd>lua vim.diagnostic.setloclist()<cr>", opts)
    c.kbmap(bufnr, "n", "glQ", "<cmd>lua vim.diagnostic.setqflist()<cr>", opts)
end

return {
    "neovim/nvim-lspconfig",
    ft = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "json",
        "html",
        "css",
        "lua",
        "clojure",
        "dockerfile",
        "rust",
        "go",
        "python",
        "bash",
        "sh",
    },
    config = function()
        vim.diagnostic.config({ virtual_text = false })

        local lsp_dir = vim.fn.stdpath("data") .. "/lsp_servers"

        local ok, lspconfig, capabilities = unpack(require_lsp())
        if ok then
            --------------------------------------------------
            ------------ Javascript/Typescript ---------------
            --------------------------------------------------

            lspconfig.tsserver.setup(
                {
                    capabilities = capabilities,
                    on_attach = function(client, bufnr)
                        client.server_capabilities.documentFormattingProvider = false
                        on_attach(client, bufnr)
                    end,
                    flags = { debounce_text_changes = 150 },
                }
            )

            --------------------------------------------------
            -------------------- Rust ------------------------
            --------------------------------------------------

            lspconfig.rust_analyzer.setup(
                { cmd = { lsp_dir .. "/rust/rust-analyzer" }, capabilities = capabilities, on_attach = on_attach }
            )

            --------------------------------------------------
            ------------------- Docker -----------------------
            --------------------------------------------------

            lspconfig.dockerls.setup({ capabilities = capabilities })

            --------------------------------------------------
            ------------------- Clojure ----------------------
            --------------------------------------------------

            lspconfig.clojure_lsp.setup({ capabilities = capabilities, on_attach = on_attach })

            --------------------------------------------------
            --------------------- Go -------------------------
            --------------------------------------------------

            lspconfig.gopls.setup({ capabilities = capabilities, on_attach = on_attach })

            --------------------------------------------------
            ------------------- Python -----------------------
            --------------------------------------------------

            lspconfig.pyright.setup({ capabilities = capabilities, on_attach = on_attach })

            --------------------------------------------------
            ------------------- Bash -------------------------
            --------------------------------------------------

            lspconfig.bashls.setup({ filetypes = { "sh", "bash" }, capabilities = capabilities, on_attach = on_attach })

            --------------------------------------------------
            --------------------- HTML -----------------------
            --------------------------------------------------

            lspconfig.html.setup({ capabilities = capabilities, on_attach = on_attach })

            --------------------------------------------------
            --------------------- CSS ------------------------
            --------------------------------------------------

            lspconfig.cssls.setup({ capabilities = capabilities, on_attach = on_attach })

            --------------------------------------------------
            -------------------- JSON ------------------------
            --------------------------------------------------

            local schemas = {
                {
                    description = "TypeScript compiler configuration file",
                    fileMatch = { "tsconfig.json", "tsconfig.*.json" },
                    url = "https://json.schemastore.org/tsconfig.json",
                },
                {
                    description = "Lerna config",
                    fileMatch = { "lerna.json" },
                    url = "https://json.schemastore.org/lerna.json",
                },
                {
                    description = "Babel configuration",
                    fileMatch = { ".babelrc.json", ".babelrc", "babel.config.json" },
                    url = "https://json.schemastore.org/babelrc.json",
                },
                {
                    description = "ESLint config",
                    fileMatch = { ".eslintrc.json", ".eslintrc" },
                    url = "https://json.schemastore.org/eslintrc.json",
                },
                {
                    description = "Prettier config",
                    fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
                    url = "https://json.schemastore.org/prettierrc",
                },
                {
                    description =
                    "AWS CloudFormation provides a common language for you to describe and provision all the infrastructure resources in your cloud environment.",
                    fileMatch = { "*.cf.json", "cloudformation.json" },
                    url =
                    "https://raw.githubusercontent.com/awslabs/goformation/v5.2.9/schema/cloudformation.schema.json",
                },
                {
                    description =
                    "The AWS Serverless Application Model (AWS SAM previously known as Project Flourish) extends AWS CloudFormation to provide a simplified way of defining the Amazon API Gateway APIs AWS Lambda functions and Amazon DynamoDB tables needed by your serverless application.",
                    fileMatch = { "serverless.template", "*.sam.json", "sam.json" },
                    url = "https://raw.githubusercontent.com/awslabs/goformation/v5.2.9/schema/sam.schema.json",
                },
                {
                    description = "NPM configuration file",
                    fileMatch = { "package.json" },
                    url = "https://json.schemastore.org/package.json",
                },
            }

            lspconfig.jsonls.setup(
                { capabilities = capabilities, settings = { json = { schemas = schemas } }, on_attach = on_attach }
            )

            --------------------------------------------------
            --------------------- Lua ------------------------
            --------------------------------------------------

            local runtime_path = vim.split(package.path, ";")
            table.insert(runtime_path, "lua/?.lua")
            table.insert(runtime_path, "lua/?/init.lua")
            lspconfig.lua_ls.setup(
                {
                    on_attach = function(client, bufnr)
                        client.server_capabilities.document_formatting = false
                        on_attach(client, bufnr)
                    end,
                    settings = {
                        Lua = {
                            runtime = { version = "LuaJIT", path = runtime_path },
                            diagnostics = { globals = { "vim", "use" } },
                            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                            telemetry = { enable = false },
                        },
                    },
                }
            )
        end
    end,
}
