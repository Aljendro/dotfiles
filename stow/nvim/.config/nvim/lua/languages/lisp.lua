local M = {}

function M.setup()
    local c = require("common")
    vim.g["conjure#highlight#enabled"] = true
    vim.g["conjure#highlight#timeout"] = 250
    vim.g["conjure#log#wrap"] = true

    ------------------------------------------------------------------------------------------------------------------------
    -- REPL
    ------------------------------------------------------------------------------------------------------------------------

    -- Opening the REPL
    c.kbmap(c.current_buf, "n", "<leader>cc", "<localleader>lv",
            { noremap = false })
    c.kbmap(c.current_buf, "n", "<leader>ct", "<localleader>lt",
            { noremap = false })
    -- Clear the REPL window
    c.kbmap(c.current_buf, "n", "<leader>cr", "<localleader>lr",
            { noremap = false })
    -- Reset the REPL
    c.kbmap(c.current_buf, "n", "<leader>cR", "<localleader>lR",
            { noremap = false })
    -- Closing the REPL
    c.kbmap(c.current_buf, "n", "<leader>cq", "<localleader>lq",
            { noremap = false })
    -- Enter at bottom of REPL
    c.kbmap(c.current_buf, "n", "<leader>ci", "Go", { noremap = true })

    ------------------------------------------------------------------------------------------------------------------------
    -- Evaluations
    ------------------------------------------------------------------------------------------------------------------------

    -- Evaluate Form Under Cursor
    c.kbmap(c.current_buf, "n", "<leader>ee", "<localleader>ee",
            { noremap = false })
    -- Evaluate Form in Visual Area
    c.kbmap(c.current_buf, "v", "<leader>ee", "<localleader>E",
            { noremap = false })
    -- Evaluate Root Form Under Cursor
    c.kbmap(c.current_buf, "n", "<leader>er", "<localleader>er",
            { noremap = false })
    -- Evaluate Editor Line
    c.kbmap(c.current_buf, "n", "<leader>el", "<S-v><localleader>E",
            { noremap = false })
    -- Evaluate Form under cursor and replace with result
    c.kbmap(c.current_buf, "n", "<leader>eo", "<localleader>e!",
            { noremap = false })
    -- Evaluate Word under cursor
    c.kbmap(c.current_buf, "n", "<leader>ew", "<localleader>ew",
            { noremap = false })
    -- Evaluate File from disk
    c.kbmap(c.current_buf, "n", "<leader>ef", "<localleader>ef",
            { noremap = false })
    -- Evaluate File from buffer
    c.kbmap(c.current_buf, "n", "<leader>eb", "<localleader>eb",
            { noremap = false })
    -- Go to documentation file
    c.kbmap(c.current_buf, "n", "<leader>ed", "<localleader>gd",
            { noremap = false })
    -- Evaluate form at mark
    c.kbmap(c.current_buf, "n", "<leader>em", "<localleader>em",
            { noremap = false })
end

return M
