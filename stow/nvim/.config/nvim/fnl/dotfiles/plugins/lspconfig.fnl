(module dotfiles.plugins.lspconfig
  {autoload {{: on-attach : require-lsp} dotfiles.core.lsp}})

(def lsp-dir (.. (vim.fn.stdpath "data") "/lsp_servers"))

(let [[ok? lspconfig capabilities] (require-lsp)]
  (when ok?
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;; Javascript/Typescript ;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    (lspconfig.tsserver.setup
       {:cmd [(.. lsp-dir  "/tsserver/node_modules/.bin/typescript-language-server" "--stdio")]
        :capabilities capabilities
        :on_attach (fn [client bufnr]
                     (tset client :server_capabilities :document_formatting false)
                     (on-attach client bufnr))
        :flags {:debounce_text_changes 150}})

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;; Rust ;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    (lspconfig.rust_analyzer.setup
        {:cmd [(.. lsp-dir  "/rust/rust-analyzer")]
         :capabilities capabilities
         :on_attach on-attach})

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;; Docker ;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    (lspconfig.dockerls.setup
       {:cmd [(.. lsp-dir  "/dockerfile/node_modules/.bin/docker-langserver" "--stdio")]
        :capabilities capabilities})

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;; Clojure ;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    (lspconfig.clojure_lsp.setup
       {:capabilities capabilities
        :on_attach on-attach})

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;; Go ;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    (lspconfig.gopls.setup
       {:cmd [(.. lsp-dir  "/go/gopls")]
        :capabilities capabilities
        :on_attach on-attach})


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;; Python ;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    (lspconfig.pyright.setup
       {:cmd [(.. lsp-dir  "/python/node_modules/.bin/pyright-langserver" "--stdio")]
        :capabilities capabilities
        :on_attach on-attach})

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;; HTML ;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    (lspconfig.html.setup
      {:cmd [(.. lsp-dir  "/html/node_modules/vscode-langservers-extracted/bin/vscode-html-language-server" "--stdio")]
       :capabilities capabilities})


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;; CSS ;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    (lspconfig.cssls.setup
       {:cmd [(.. lsp-dir  "/cssls/node_modules/vscode-langservers-extracted/bin/vscode-css-language-server" "--stdio")]
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
        {:cmd [(.. lsp-dir "/jsonls/node_modules/vscode-langservers-extracted/bin/vscode-json-language-server" "--stdio")]
         :capabilities capabilities
         :settings {:json {:schemas schemas}}
         :on_attach on-attach})

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;; Lua ;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    (def runtime_path (vim.split package.path ";"))
    (table.insert runtime_path "lua/?.lua")
    (table.insert runtime_path "lua/?/init.lua")
    (lspconfig.sumneko_lua.setup
       {:on_attach (fn [client bufnr]
                     (tset client :server_capabilities :document_formatting false)
                     (on-attach client bufnr))
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
       {:cmd [(.. lsp-dir "/efm/efm-langserver")]
        :init_options {:documentFormatting true}
        :filetypes ["lua" "javascript" "javascriptreact" "typescript" "typescriptreact"]
        :settings {:rootMarkers [".git/"]
                   :languages {:lua [{:formatCommand "lua-format -i" :formatStdin true}]
                               :javascript [prettier eslint]
                               :javascriptreact [prettier eslint]
                               :typescript [prettier eslint]
                               :typescriptreact [prettier eslint]}}})))

