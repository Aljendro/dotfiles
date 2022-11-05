local M = {}

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

function M.t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

return M
