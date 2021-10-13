-- Neovim init settings
--
-- Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
--
-- TODO: This config is in early of being converted to lua
-- Its a "make it work" stage and settings/configs/functions
-- are in progress.
-- Will clean this up once all my settings are working properly
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

function _G.put(...)
    local objects = {}
    for i = 1, select('#', ...) do
        local v = select(i, ...)
        table.insert(objects, vim.inspect(v))
    end

    print(table.concat(objects, '\n'))
    return ...
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    -- Mappings.
    local opts = {
        noremap = true,
        silent = true
    }

    -- See `:help vim.lsp.*` for documentation on any of the below functions

    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    buf_set_keymap('n', 'gK', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    buf_set_keymap('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    buf_set_keymap('n', 'gT', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    buf_set_keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    buf_set_keymap('n', 'gk', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    buf_set_keymap('n', 'gv',
                   '<cmd>vsplit<cr><cmd>lua vim.lsp.buf.definition()<cr>', opts)
    buf_set_keymap('n', 'gt',
                   '<cmd>tab split<cr><cmd>lua vim.lsp.buf.definition()<cr>',
                   opts)
    buf_set_keymap('n', '[g', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>',
                   opts)
    buf_set_keymap('n', ']g', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>',
                   opts)
    buf_set_keymap('n', 'gla',
                   '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>', opts)
    buf_set_keymap('n', 'glf', '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)
    buf_set_keymap('n', 'glq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>',
                   opts)
    buf_set_keymap('n', 'glr',
                   '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>', opts)
    buf_set_keymap('n', 'glw',
                   '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>',
                   opts)

end

cmp.setup({
    snippet = {
        expand = function(args) vim.fn["UltiSnips#Anon"](args.body) end
    },
    sources = {
        {
            name = 'nvim_lsp',
            preselect = true
        }, {
            name = 'ultisnips'
        }, {
            name = 'buffer'
        }
    },
    mapping = {
        ['<cr>'] = cmp.mapping.confirm({
            select = true
        }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if vim.fn.complete_info()["selected"] == -1 and
                vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
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
        end, {"i", "s"}),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                return vim.fn.feedkeys(t("<C-R>=UltiSnips#JumpBackwards()<cr>"))
            elseif vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(t("<C-p>"), "n")
            else
                fallback()
            end
        end, {"i", "s"})
    }
})

-- Merge two tables together
local function merge(t0, t1)
    local c = {}
    if t0 == nil then t0 = {} end
    if t1 == nil then t1 = {} end

    for k, v in pairs(t0) do c[k] = v end
    for k, v in pairs(t1) do c[k] = v end

    return c
end

local servers = {
    bash = {},
    clojure = {},
    css = {},
    dockerfile = {},
    html = {},
    json = {},
    lua = {
        self_disable_formatter = true, -- Don't use LSP formatter
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                    -- Setup your lua path
                    path = vim.split(package.path, ';')
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {'vim', 'use', 'use_rocks'}
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = {
                        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
                    }
                }
            }
        }
    },
    rust = {},
    typescript = {
        self_disable_formatter = true -- Don't use LSP formatter
    },
    vim = {},
    yaml = {}
}

require'lspinstall'.setup()

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
for lsp, custom_setting in pairs(servers) do
    nvim_lsp[lsp].setup(merge({
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp
                                                                       .protocol
                                                                       .make_client_capabilities()),
        on_attach = function(client, bufnr)
            if custom_setting.self_disable_formatter then
                client.resolved_capabilities.document_formatting =
                    not custom_setting.self_disable_formatter
            end
            on_attach(client, bufnr)
        end,
        settings = {
            documentFormatting = false
        },
        handlers = {
            ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp
                                                                   .diagnostic
                                                                   .on_publish_diagnostics,
                                                               {
                virtual_text = false,
                underline = true,
                signs = true
            })
        },
        flags = {
            debounce_text_changes = 150
        }
    }, custom_setting))
end

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

-- Custom LSP Config
nvim_lsp['efm'].setup({
    init_options = {
        documentFormatting = true
    },
    filetypes = {
        "lua", "javascript", "javascript", "javascriptreact", "typescript",
        "typescriptreact"
    },
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic
                                                               .on_publish_diagnostics,
                                                           {
            virtual_text = false,
            underline = true,
            signs = true
        })
    },
    settings = {
        rootMarkers = {".git/"},
        languages = {
            lua = {
                {
                    formatCommand = "$HOME/.luarocks/bin/lua-format -i",
                    formatStdin = true
                }
            },
            javascript = {prettier, eslint},
            javascriptreact = {prettier, eslint},
            typescript = {prettier, eslint},
            typescriptreact = {prettier, eslint}
        }
    }
})

dap.adapters.node2 = {
    type = 'executable',
    command = 'node',
    args = {
        os.getenv('HOME') ..
            '/.local/share/nvim/dapinstall/jsnode/vscode-node-debug2/out/src/nodeDebug.js'
    }
}

local signs = {
    LspDiagnosticsSignError = "💢",
    LspDiagnosticsSignWarning = "⚠️ ",
    LspDiagnosticsSignHint = "💬",
    LspDiagnosticsSignInformation = "📜",
    DapBreakpoint = '🟩',
    DapCondition = '🟧',
    DapBreakpointRejected = '🟥',
    DapStopped = '➡️',
    DapLogPoint = '📓'
}

for hl, icon in pairs(signs) do
    vim.fn.sign_define(hl, {
        text = icon,
        texthl = "SignColumn",
        linehl = "",
        numhl = ""
    })
end

require('telescope').load_extension('fzf')
require('telescope').load_extension('dap')
require('gitsigns').setup()
require('hop').setup({
    keys = 'fjdksla;rueiwovmcxtyz',
    term_seq_bias = 0.5
})
require('nvim-ts-autotag').setup()
require('nvim-treesitter.configs').setup({
    ensure_installed = 'all',
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },
    incremental_selection = {
        enable = false,
        keymaps = {
            init_selection = "gnn",
            node_decremental = "grm",
            node_incremental = "grn",
            scope_incremental = "grc"
        }
    },
    indent = {
        enable = true
    }
})
