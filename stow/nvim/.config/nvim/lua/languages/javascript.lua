local function jest_debug_nearest()
    local original_executable = vim.g["test#javascript#jest#executable"]
    vim.g["test#javascript#jest#executable"] =
        "node --inspect-brk $(which jest)"
    vim.cmd("TestNearest")
    vim.g["test#javascript#jest#executable"] = original_executable
end

local M = {}

function M.setup()
    local c = require("common")
    -- Options
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"

    -- Testing
    vim.g["test#javascript#runner"] = "jest"
    vim.g["test#javascript#jest#file_pattern"] =
        "\\v(__tests__/.*|(spec|test|integration))\\.(js|jsx|ts|tsx)$"
    vim.g["test#javascript#jest#options"] =
        "--testRegex=\"(/__tests__/.*|(\\.|/)(test|spec|integration))\\.[jt]sx?$\""
    vim.cmd("iabbrev <buffer> d; debugger;")
    c.kbmapset(c.current_buf, "n", "<leader>ti", jest_debug_nearest)

    -- Running scripts
    c.kbmap(c.current_buf, "n", "<leader>rr",
            ":lua require('harpoon.term').sendCommand(1, 'node ' . expand('%:p') . ' ')<left><left>")
    c.kbmap(c.current_buf, "n", "<leader>ri",
            ":lua require('harpoon.term').sendCommand(1, 'node --inspect-brk ' . expand('%:p') . ' ')<left><left>")
end

return M
