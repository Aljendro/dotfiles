(module dotfiles.plugins.csv
  {autoload {{: kbmap : current-buf} dotfiles.core.common}})

(kbmap current-buf :n "<localleader>j" ":%!csvtojson | jq -c '.[]'<cr>" {:noremap true})

