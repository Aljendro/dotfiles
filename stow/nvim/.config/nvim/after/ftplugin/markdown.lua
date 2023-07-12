local c = require("common")

vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

-- Reflow bases on column length
c.kbmap(c.current_buf, "n", "<leader>fm", "vapgq", { silent = true })

c.kbmap(c.current_buf, "n", "<C-f>", ":MarkdownPreviewToggle<cr>", { silent = true })
c.kbmap(c.current_buf, "n", "<leader><leader>p", ":lua ToggleListItem('🚧')<cr>", { silent = true })
c.kbmap(c.current_buf, "n", "<leader><leader>r", ":lua ToggleListItem('🚀')<cr>", { silent = true })
