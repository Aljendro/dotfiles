-- Do not lose focus of quickfix when pressing enter
vim.api.nvim_buf_set_keymap('n', '<cr>', '<CR><C-w>p', { silent = true })
-- Deleting a line immediately saves the buffer
vim.api.nvim_buf_set_keymap('n', 'dd', 'dd:w<cr>', { silent = true })
