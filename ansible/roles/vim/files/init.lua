require('plugins')

vim.cmd("source ~/.vimrc")

local cmp = require'cmp'
local nvim_lsp = require('lspconfig')

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
  buf_set_keymap('n','gT' ,'<cmd>lua vim.lsp.buf.type_definition()<CR>'                           ,opts)
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
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
    { name = 'buffer' },
  }
})

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

