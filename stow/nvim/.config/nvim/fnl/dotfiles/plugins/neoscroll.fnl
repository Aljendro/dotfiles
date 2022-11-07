(module dotfiles.plugins.neoscroll
  {autoload {{: kmap : kunmap} dotfiles.core.common}})

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn- unmap-keymaps []
  (pcall kunmap "n" "<C-k>")
  (pcall kunmap "n" "<C-j>")
  (pcall kunmap "n" "<Up>")
  (pcall kunmap "n" "<Down>")
  (pcall kunmap "n" "<PageDown>")
  (pcall kunmap "n" "<PageUp>")
  (pcall kunmap "x" "<C-k>")
  (pcall kunmap "x" "<C-j>")
  (pcall kunmap "x" "<Up>")
  (pcall kunmap "x" "<Down>")
  (pcall kunmap "x" "<PageDown>")
  (pcall kunmap "x" "<PageUp>"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Keymap Setters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(var toggled false)

(defn- set-normal-keymaps []
  (unmap-keymaps)
  (kmap :n "<C-k>" "<C-u>")
  (kmap :n "<C-j>" "<C-d>")
  (kmap :n "<PageUp>" "<C-b>")
  (kmap :n "<PageDown>" "<C-f>")
  (kmap :n "<Up>" "5<C-y>")
  (kmap :n "<Down>" "5<C-e>")
  (kmap :x "<C-k>" "<C-u>")
  (kmap :x "<C-j>" "<C-d>")
  (kmap :x "<PageUp>" "<C-b>")
  (kmap :x "<PageDown>" "<C-f>")
  (kmap :x "<Up>" "5<C-y>")
  (kmap :x "<Down>" "5<C-e>")
  (set toggled false))

(def- neoscroll-config-table
  {"<C-j>" [:scroll ["vim.wo.scroll" "true" "150"]]
   "<C-k>" [:scroll ["-vim.wo.scroll" "true" "150"]]
   "<PageDown>" [:scroll ["vim.api.nvim_win_get_height(0)" "true" "250"]]
   "<PageUp>" [:scroll ["-vim.api.nvim_win_get_height(0)" "true" "250"]]
   "<Up>" [:scroll ["-0.20" "false" "100"]]
   "<Down>" [:scroll ["0.20" "false" "100"]]})

(defn- set-neoscroll-keymaps []
  (let [(ok? neoscroll-config) (pcall require "neoscroll.config")]
    (when ok?
      (unmap-keymaps)
      (neoscroll-config.set_mappings neoscroll-config-table)
      (set toggled true))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Public Api
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn ToggleSmoothScroll []
    (if toggled
      (set-normal-keymaps)
      (set-neoscroll-keymaps)))

(defn setup []
  (let [(ok? neoscroll) (pcall require "neoscroll")]
    (when ok?
      (neoscroll.setup {:mappings {} :hide_cursor true}))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initial Setup On Load
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(set-normal-keymaps)

