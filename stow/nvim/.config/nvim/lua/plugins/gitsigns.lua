return {
    "lewis6991/gitsigns.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local c = require("common")
        require("gitsigns").setup({
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                c.kbmapset(bufnr, "n", "]c", function()
                    if vim.wo.diff then
                        return "]c"
                    else
                        vim.schedule(function()
                            gs.next_hunk()
                            vim.cmd("normal! zz")
                        end)
                        return "<Ignore>"
                    end
                end, { expr = true })
                c.kbmapset(bufnr, "n", "[c", function()
                    if vim.wo.diff then
                        return "[c"
                    else
                        vim.schedule(function()
                            gs.prev_hunk()
                            vim.cmd("normal! zz")
                        end)
                        return "<Ignore>"
                    end
                end, { expr = true })
                c.kbmapset(bufnr, "n", "<leader>hs", gs.stage_hunk)
                c.kbmapset(bufnr, "v", "<leader>hs", function()
                    gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") }
                end)
                c.kbmapset(bufnr, "n", "<leader>hr", gs.reset_hunk)
                c.kbmapset(bufnr, "v", "<leader>hr", function()
                    gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") }
                end)
                c.kbmapset(bufnr, "n", "<leader>hS", gs.stage_buffer)
                c.kbmapset(bufnr, "n", "<leader>hu", gs.undo_stage_hunk)
                c.kbmapset(bufnr, "n", "<leader>hR", gs.reset_buffer)
                c.kbmapset(bufnr, "n", "<leader>hp", gs.preview_hunk)
                c.kbmapset(bufnr, "n", "<leader>ho", gs.toggle_deleted)
                c.kbmapset(bufnr, "n", "<leader>hb",
                           function()
                    gs.blame_line({ full = true })
                end)
                c.kbmapset(bufnr, "n", "<leader>hd",
                           function() gs.diffthis() end)
                c.kbmapset(bufnr, "n", "<leader>hD",
                           function() gs.diffthis("~") end)
            end,
        })
    end,
};
