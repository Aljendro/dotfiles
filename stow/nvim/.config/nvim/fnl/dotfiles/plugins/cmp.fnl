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

(let [(cmp-ok? cmp) (pcall require "cmp")
      (cmp-ultisnips-ok? cmp-ultisnips) (pcall require "cmp_nvim_ultisnips.mappings")]
  (when (and cmp-ok? cmp-ultisnips-ok?)
    (cmp.setup
      {:experimental {:ghost_text true}
       :formatting {:format
                    (fn [_ vim_item]
                      (set vim_item.kind (string.format "%s %s" (. kind_icons vim_item.kind) vim_item.kind))
                      (set vim_item.menu "")
                      vim_item)}
       :snippet {:expand (fn [args] ((. vim.fn "UltiSnips#Anon") args.body))}
       :matching {:disallow_fuzzy_matching false}
       :window {:completion (cmp.config.window.bordered)
                :documentation (cmp.config.window.bordered)}
       :sources (cmp.config.sources
                  [{:name "nvim_lsp" :preselect true :keyword_length 2 :group_index 1}
                   {:name "ultisnips" :preselect true :keyword_length 2 :group_index 1}
                   {:name "buffer" :preselect true :keyword_length 4 :max_item_count 20 :option {:keyword_pattern "\\k\\k\\k\\+"} :group_index 2}
                   {:name "nvim_lsp_signature_help" :group_index 3}
                   {:name "path" :group_index 4}])
       :mapping {"<Tab>" (cmp.mapping
                           (fn [fallback]
                             ((cmp-ultisnips.compose ["expand" "jump_forwards"]) fallback))
                           ["i" "s"])
                 "<S-Tab>" (cmp.mapping
                             (fn [fallback]
                               ((cmp-ultisnips.compose ["jump_backwards"]) fallback))
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
                   {:name "buffer" :keyword_length 3 :group_index 3}])})))

