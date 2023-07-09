local c = require("common")
-- Do not lose focus of quickfix when pressing enter
c.kbmap(c.current_buf, "n", "<cr>", "<CR><C-w>p", { silent = true })
-- Deleting a line immediately saves the buffer
c.kbmap(c.current_buf, "n", "dd", "dd:w<cr>", { silent = true })
