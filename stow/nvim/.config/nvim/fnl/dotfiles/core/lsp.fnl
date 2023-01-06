(module dotfiles.core.lsp
  {require {{: kbmap} dotfiles.core.common}})

(vim.diagnostic.config {:virtual_text false})

(defn require-lsp []
  (let [(lspconfig-ok? lspconfig) (pcall require "lspconfig")
        (cmp-nvim-lsp-ok? cmp-nvim-lsp) (pcall require "cmp_nvim_lsp")
        requires-ok? (and lspconfig-ok? cmp-nvim-lsp-ok?)]
    (if (not requires-ok?)
      [false]
      (let [capabilities
            (cmp-nvim-lsp.default_capabilities
              (vim.lsp.protocol.make_client_capabilities))]
        [true lspconfig capabilities]))))

;; Use an on_attach function to only map the following keys
;; after the language server attaches to the current buffer
(defn on-attach [client bufnr]
  "Set the keypmaps for LSP functionality."
  ;; See `:help vim.lsp.*` for documentation on any of the below functions
  (let [opts {:silent true}]
    (kbmap bufnr "n" "gD" "<cmd>lua vim.lsp.buf.declaration()<cr>" opts)
    (kbmap bufnr "n" "gk" "<cmd>lua vim.lsp.buf.signature_help()<cr>" opts)
    (kbmap bufnr "n" "gR" "<cmd>lua vim.lsp.buf.rename()<cr>" opts)
    (kbmap bufnr "n" "gT" "<cmd>lua vim.lsp.buf.type_definition()<cr>" opts)
    (kbmap bufnr "n" "ga" "<cmd>lua vim.lsp.buf.code_action()<cr>" opts)
    (kbmap bufnr "x" "ga" "<cmd>lua vim.lsp.buf.code_action()<cr>" opts)
    (kbmap bufnr "n" "gd" "<cmd>lua vim.lsp.buf.definition()<cr>" opts)
    (kbmap bufnr "n" "gi" "<cmd>lua vim.lsp.buf.implementation()<cr>" opts)
    (kbmap bufnr "n" "K" "<cmd>lua vim.lsp.buf.hover()<cr>" opts)
    (kbmap bufnr "n" "gr" "<cmd>lua vim.lsp.buf.references()<cr>" opts)
    (kbmap bufnr "n" "glf" "<cmd>lua vim.lsp.buf.format({ async = true })<cr>" opts)
    (kbmap bufnr "x" "glf" "<cmd>lua vim.lsp.buf.format({ async = true })<cr>" opts)
    (kbmap bufnr "n" "gs" "<cmd>vsplit<cr><cmd>lua vim.lsp.buf.definition()<cr>" opts)
    (kbmap bufnr "n" "gt" "<cmd>tab split<cr><cmd>lua vim.lsp.buf.definition()<cr>" opts)
    (kbmap bufnr "n" "gla" "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>" opts)
    (kbmap bufnr "n" "glr" "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>" opts)
    (kbmap bufnr "n" "glw" "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>" opts)
    (kbmap bufnr "n" "gld" "<cmd>lua vim.diagnostic.open_float()<cr>" opts)
    (kbmap bufnr "n" "glq" "<cmd>lua vim.diagnostic.setloclist()<cr>" opts)
    (kbmap bufnr "n" "glQ" "<cmd>lua vim.diagnostic.setqflist()<cr>" opts)))

