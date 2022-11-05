(module dotfiles.plugins.telescope
  {autoload {: telescope
             actions telescope.actions}})

(telescope.setup
  {:defaults
   {:mappings
    {:i {"<C-j>" actions.move_selection_next
         "<C-k>" actions.move_selection_previous}
     :n {"<C-j>" actions.move_selection_next
         "<C-k>" actions.move_selection_previous}}
    :cache_picker {:num_pickers 20}
    :layout_strategy "flex"
    :layout_config {:height 0.95
                    :width 0.95
                    :vertical {:preview_height 0.45}
                    :horizontal {:preview_width 0.50}}}})

(telescope.load_extension "fzf")

