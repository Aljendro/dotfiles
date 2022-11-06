(module dotfiles.languages.csv
  {autoload {{: kbmap : current-buf} dotfiles.core.common}})

(defn setup []
  (kbmap current-buf :n "<leader>j" ":%!csvtojson | jq -c '.[]'<cr>"))

