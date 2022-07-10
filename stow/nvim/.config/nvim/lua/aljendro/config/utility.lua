local M = {}

M.lsp_dir = vim.fn.stdpath('data') .. '/lsp_servers'

-- Pretty print
function _G.put(...)
    local objects = {}
    for i = 1, select('#', ...) do
        local v = select(i, ...)
        table.insert(objects, vim.inspect(v))
    end

    print(table.concat(objects, '\n'))
    return ...
end

-- Merge two tables together
function M.merge(t0, t1)
    local c = {}
    if t0 == nil then t0 = {} end
    if t1 == nil then t1 = {} end

    for k, v in pairs(t0) do c[k] = v end
    for k, v in pairs(t1) do c[k] = v end

    return c
end

function M.t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

return M
