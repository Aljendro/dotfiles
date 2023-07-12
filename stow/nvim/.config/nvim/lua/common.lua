local M = {}

M.current_buf = 0

-- Sets a mapping with ('options' default to {noremap = true}).
function M.kmap(mode, from, to, options)
    local default_options = { noremap = true }
    if options ~= nil then for key, value in pairs(options) do default_options[key] = value end end
    vim.api.nvim_set_keymap(mode, from, to, default_options)
end

-- Sets a buffer mapping with ('options' default to {noremap = true}).
function M.kbmap(bufnr, mode, from, to, options)
    local default_options = { noremap = true }
    if options ~= nil then for key, value in pairs(options) do default_options[key] = value end end
    vim.api.nvim_buf_set_keymap(bufnr, mode, from, to, default_options)
end

-- Sets a buffer mapping.
function M.kbmapset(bufnr, mode, from, str_or_fn, options)
    local default_options = options or {}
    default_options.buffer = bufnr
    vim.keymap.set(mode, from, str_or_fn, default_options)
end

-- Unsets a mapping.
function M.kunmap(mode, keypress) vim.api.nvim_del_keymap(mode, keypress) end

return M
