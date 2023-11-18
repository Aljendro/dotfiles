local c = require("common")
c.kbmap(c.current_buf, "n", "<leader><leader>j", ":%!csvtojson | jq -c '.[]'<cr>")
