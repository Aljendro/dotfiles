(module dotfiles.plugins.lualine)

(let [(ok? lualine) (pcall require "lualine")]
  (lualine.setup
    {:options {:theme "tokyonight" :globalstatus true}
     :sections {:lualine_c [(let [val {}]
                              (table.insert val "filename")
                              (tset val :path 1)
                              val)]
                :lualine_x ["lsp_progress" "encoding" "fileformat" "filetype"]}
     :tabline {:lualine_a [(let [val {}]
                             (table.insert val "buffers")
                             (tset val :mode 0)
                             val)]
               :lualine_b []
               :lualine_c []
               :lualine_x []
               :lualine_y []
               :lualine_z ["tabs"]}}))

