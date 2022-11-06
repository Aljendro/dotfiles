(module dotfiles.core.common)

(def current-buf 0)

(defn kmap [mode from to options]
  "Sets a mapping with ('options' default to {:noremap true})."
  (let [default-options {:noremap true}]
    (when (not (= options nil))
      (each [key value (pairs options)]
        (tset default-options key value)))
    (vim.api.nvim_set_keymap mode from to default-options)))

(defn kbmap [bufnr mode from to options]
  "Sets a buffer mapping with ('options' default to {:noremap true})."
  (let [default-options {:noremap true}]
    (when (not (= options nil))
      (each [key value (pairs options)]
        (tset default-options key value)))
    (vim.api.nvim_buf_set_keymap bufnr mode from to default-options)))

(defn kbmapset [bufnr mode from str-or-fn options]
  "Sets a buffer mapping."
  (let [default-options (or options {})]
    (tset default-options :buffer bufnr)
    (vim.keymap.set mode from str-or-fn default-options)))

(defn kunmap [mode keypress]
  "Unsets a mapping."
  (vim.api.nvim_del_keymap mode keypress))

