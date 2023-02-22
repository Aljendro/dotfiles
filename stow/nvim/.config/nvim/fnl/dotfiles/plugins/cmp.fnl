(module dotfiles.plugins.cmp)

(def kind_icons
  {:Class "ﴯ"
   :Color ""
   :Constant ""
   :Constructor ""
   :Enum ""
   :EnumMember ""
   :Event ""
   :Field ""
   :File ""
   :Folder ""
   :Function ""
   :Interface ""
   :Keyword ""
   :Method ""
   :Module ""
   :Operator ""
   :Property "ﰠ"
   :Reference ""
   :Snippet ""
   :Struct ""
   :Text ""
   :TypeParameter ""
   :Unit ""
   :Value ""
   :Variable ""})

(defn setup []
  (let [(cmp-ok? cmp) (pcall require "cmp")
        (cmp-luasnip-ok? cmp-luasnip) (pcall require "luasnip")
        (cmp-npm-ok? cmp-npm) (pcall require "cmp-npm")]
    (when (and cmp-ok? cmp-luasnip-ok? cmp-npm-ok?)
      (cmp-npm.setup {})
      (cmp.setup
        {:experimental {:ghost_text true}
         :formatting {:format
                      (fn [_ vim_item]
                        (set vim_item.kind (string.format "%s %s" (. kind_icons vim_item.kind) vim_item.kind))
                        (set vim_item.menu "")
                        vim_item)}
         :snippet {:expand (fn [args] (cmp-luasnip.lsp_expand args.body))}
         :matching {:disallow_fuzzy_matching false}
         :window {:completion (cmp.config.window.bordered)
                  :documentation (cmp.config.window.bordered)}
         :sources (cmp.config.sources
                    [{:name "npm" :keyword_length 4}
                     {:name "nvim_lsp" :preselect true :keyword_length 2 :group_index 1}
                     {:name "luasnip" :preselect true :keyword_length 2 :group_index 1}
                     {:name "buffer" :preselect true :keyword_length 4 :max_item_count 20 :option {:keyword_pattern "\\k\\k\\k\\+"} :group_index 2}
                     {:name "nvim_lsp_signature_help" :group_index 3}
                     {:name "path" :group_index 4}])
         :mapping {"<Tab>" (cmp.mapping
                             (fn [fallback]
                               (if (cmp-luasnip.expand_or_jumpable)
                                   (cmp-luasnip.expand_or_jump)
                                   (fallback)))
                             ["i" "s"])
                   "<S-Tab>" (cmp.mapping
                               (fn [fallback]
                                 (if (cmp-luasnip.jumpable -1)
                                     (cmp-luasnip.jump -1)
                                     (fallback)))
                               ["i" "s"])
                   "<M-j>" (cmp.mapping (cmp.mapping.scroll_docs 4) ["i"])
                   "<M-k>" (cmp.mapping (cmp.mapping.scroll_docs -4) ["i"])
                   "<C-j>" (cmp.mapping
                             (fn [fallback]
                               (if (cmp.visible)
                                 (cmp.select_next_item {:behavior cmp.SelectBehavior.Select})
                                 (fallback)))
                             ["i" "c"])
                   "<C-k>" (cmp.mapping
                             (fn [fallback]
                               (if (cmp.visible)
                                 (cmp.select_prev_item {:behavior cmp.SelectBehavior.Select})
                                 (fallback)))
                             ["i" "c"])
                   "<C-Space>" (cmp.mapping
                                 (fn []
                                   (if (cmp.visible)
                                     (cmp.close)
                                     (cmp.complete)))
                                 ["i" "c"])
                   "<CR>" (cmp.mapping
                            (fn [fallback]
                              (if (cmp.visible)
                                (cmp.confirm {:select true})
                                (fallback)))
                            ["i" "c"])}})

      (cmp.setup.cmdline ":"
        {:mapping (cmp.mapping.preset.cmdline)
         :completion {:autocomplete false}
         :sources (cmp.config.sources
                    [{:name "path" :keyword_length 3 :group_index 1}
                     {:name "cmdline" :keyword_length 3 :group_index 2}
                     {:name "buffer" :keyword_length 3 :group_index 3}])}))))

