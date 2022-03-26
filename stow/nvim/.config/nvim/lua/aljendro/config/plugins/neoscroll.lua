require('neoscroll').setup({mappings = {}, hide_cursor = true})

local t = {}
-- Syntax: t[keys] = {function, {function arguments}}
t['<C-k>'] = {'scroll', {'-vim.wo.scroll', 'true', '100'}}
t['<C-j>'] = {'scroll', {'vim.wo.scroll', 'true', '100'}}
t['<M-k>'] = {'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '200'}}
t['<M-j>'] = {'scroll', {'vim.api.nvim_win_get_height(0)', 'true', '200'}}
t['<Up>'] = {'scroll', {'-0.10', 'false', '15'}}
t['<Down>'] = {'scroll', {'0.10', 'false', '15'}}

require('neoscroll.config').set_mappings(t)
