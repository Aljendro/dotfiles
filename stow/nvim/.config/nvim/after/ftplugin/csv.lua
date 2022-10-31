vim.api.nvim_set_keymap('n', '<localleader>j', [[:%!csvtojson \| jq -c '.[]'<cr>]], { noremap = true })
