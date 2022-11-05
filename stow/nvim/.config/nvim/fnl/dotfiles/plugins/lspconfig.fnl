(module dotfiles.plugins.lspconfig
  {autoload {{: kbmap} dotfiles.core.common
             : lspconfig
             cmp-nvim-lsp cmp_nvim_lsp}})

(def lsp_dir (.. (vim.fn.stdpath "data") "/lsp_servers"))
(def opts {:noremap true :silent true})

(vim.diagnostic.config {:virtual_text false})

;; Use an on_attach function to only map the following keys
;; after the language server attaches to the current buffer
(defn on_attach [client bufnr]
  "Set the keypmaps for LSP functionality."
  ;; See `:help vim.lsp.*` for documentation on any of the below functions
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
  (kbmap bufnr "n" "glf" "<cmd>lua vim.lsp.buf.format({ async true })<cr>" opts)
  (kbmap bufnr "n" "gs" "<cmd>vsplit<cr><cmd>lua vim.lsp.buf.definition()<cr>" opts)
  (kbmap bufnr "n" "gt" "<cmd>tab split<cr><cmd>lua vim.lsp.buf.definition()<cr>" opts)
  (kbmap bufnr "n" "gla" "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>" opts)
  (kbmap bufnr "n" "glr" "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>" opts)
  (kbmap bufnr "n" "glw" "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>" opts)
  (kbmap bufnr "n" "gld" "<cmd>lua vim.diagnostic.open_float()<cr>" opts)
  (kbmap bufnr "n" "glq" "<cmd>lua vim.diagnostic.setloclist()<cr>" opts)
  (kbmap bufnr "n" "glQ" "<cmd>lua vim.diagnostic.setqflist()<cr>" opts))

(def capabilities
  (cmp-nvim-lsp.default_capabilities
    (vim.lsp.protocol.make_client_capabilities)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; Rust ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(lspconfig.rust_analyzer.setup
    {:cmd [(.. lsp_dir  "/rust/rust-analyzer")]
     :capabilities capabilities
     :on_attach on_attach})

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;; Docker ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(lspconfig.dockerls.setup
   {:cmd [(.. lsp_dir  "/dockerfile/node_modules/.bin/docker-langserver" "--stdio")]
    :capabilities capabilities})

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;; Clojure ;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(lspconfig.clojure_lsp.setup
   {:capabilities capabilities
    :on_attach on_attach})

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; Go ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(lspconfig.gopls.setup
   {:cmd [(.. lsp_dir  "/go/gopls")]
    :capabilities capabilities
    :on_attach on_attach})


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;; Python ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(lspconfig.pyright.setup
   {:cmd [(.. lsp_dir  "/python/node_modules/.bin/pyright-langserver" "--stdio")]
    :capabilities capabilities
    :on_attach on_attach})

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; Javascript/Typescript ;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(lspconfig.tsserver.setup
   {:cmd [(.. lsp_dir  "/tsserver/node_modules/.bin/typescript-language-server" "--stdio")]
    :capabilities capabilities
    :on_attach (fn [client bufnr]
                 (tset client :server_capabilities :document_formatting false)
                 (on_attach client bufnr))
    :flags {:debounce_text_changes 150}})


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; HTML ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(lspconfig.html.setup
  {:cmd [(.. lsp_dir  "/html/node_modules/vscode-langservers-extracted/bin/vscode-html-language-server" "--stdio")]
   :capabilities capabilities})


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; CSS ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(lspconfig.cssls.setup
   {:cmd [(.. lsp_dir  "/cssls/node_modules/vscode-langservers-extracted/bin/vscode-css-language-server" "--stdio")]
    :capabilities capabilities})

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; JSON ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def schemas
   [{:description "TypeScript compiler configuration file"
     :fileMatch ["tsconfig.json" "tsconfig.*.json"]
     :url "https://json.schemastore.org/tsconfig.json"}
    {:description "Lerna config"
     :fileMatch ["lerna.json"]
     :url "https://json.schemastore.org/lerna.json"}
    {:description "Babel configuration"
     :fileMatch [".babelrc.json" ".babelrc" "babel.config.json"]
     :url "https://json.schemastore.org/babelrc.json"}
    {:description "ESLint config"
     :fileMatch [".eslintrc.json" ".eslintrc"]
     :url "https://json.schemastore.org/eslintrc.json"}
    {:description "Prettier config"
     :fileMatch [".prettierrc" ".prettierrc.json" "prettier.config.json"]
     :url "https://json.schemastore.org/prettierrc"}
    {:description "AWS CloudFormation provides a common language for you to describe and provision all the infrastructure resources in your cloud environment."
     :fileMatch ["*.cf.json" "cloudformation.json"]
     :url "https://raw.githubusercontent.com/awslabs/goformation/v5.2.9/schema/cloudformation.schema.json"}
    {:description "The AWS Serverless Application Model (AWS SAM previously known as Project Flourish) extends AWS CloudFormation to provide a simplified way of defining the Amazon API Gateway APIs AWS Lambda functions and Amazon DynamoDB tables needed by your serverless application."
     :fileMatch ["serverless.template" "*.sam.json" "sam.json"]
     :url "https://raw.githubusercontent.com/awslabs/goformation/v5.2.9/schema/sam.schema.json"}
    {:description "NPM configuration file"
     :fileMatch ["package.json"]
     :url "https://json.schemastore.org/package.json"}])

(lspconfig.jsonls.setup
    {:cmd [(.. lsp_dir "/jsonls/node_modules/vscode-langservers-extracted/bin/vscode-json-language-server" "--stdio")]
     :capabilities capabilities
     :settings {:json {:schemas schemas}}
     :on_attach on_attach})

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; Lua ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def runtime_path (vim.split package.path ";"))
(table.insert runtime_path "lua/?.lua")
(table.insert runtime_path "lua/?/init.lua")
(lspconfig.sumneko_lua.setup
   {:on_attach (fn [client bufnr]
                 (tset client :server_capabilities :document_formatting false)
                 (on_attach client bufnr))
    :settings {:Lua
               {:runtime {:version "LuaJIT"
                          :path runtime_path}
                :diagnostics {:globals ["vim" "use"]}
                :workspace {:library (vim.api.nvim_get_runtime_file "" true)}
                :telemetry {:enable false}}}})

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; EFM ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def prettier
   {:formatCommand "prettier --stdin-filepath ${INPUT}"
    :formatStdin true})

(def eslint
   {:lintCommand "eslint_d -f unix --stdin --stdin-filename ${INPUT}"
    :lintIgnoreExitCode true
    :lintStdin true
    :lintFormats ["%f:%l:%c: %m"]})

(lspconfig.efm.setup
   {:cmd [(.. lsp_dir "/efm/efm-langserver")]
    :init_options {:documentFormatting true}
    :filetypes ["lua" "javascript" "javascriptreact" "typescript" "typescriptreact"]
    :settings {:rootMarkers [".git/"]
               :languages {:lua [{:formatCommand "lua-format -i" :formatStdin true}]
                           :javascript [prettier eslint]
                           :javascriptreact [prettier eslint]
                           :typescript [prettier eslint]
                           :typescriptreact [prettier eslint]}}})



