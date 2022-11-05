(module dotfiles.core.common)

(defn kmap [mode from to options]
  "Sets a mapping with ('options' default to {:noremap true})."
  (let [default-options {:noremap true}]
    (when (not (= options nil))
      (each [key value (pairs options)]
        (tset default-options key value)))
    (vim.api.nvim_set_keymap mode from to default-options)))

(defn kunmap [mode keypress]
  "Unsets a mapping."
  (vim.api.nvim_del_keymap mode keypress))

(defn kbmap [bufnr mode from to options]
  "Sets a buffer mapping."
  (let [default-options (or options {})]
    (tset default-options :buffer bufnr)
    (vim.keymap.set mode from to default-options))

  (let [default-options (or nil {})]
    (tset default-options :buffer 1)
    default-options))
