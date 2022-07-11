require('gitsigns').setup({
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function()
                gs.next_hunk()
                vim.cmd('normal! zz')
            end)
            return '<Ignore>'
        end, {expr = true})

        map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function()
                gs.prev_hunk()
                vim.cmd('normal! zz')
            end)
            return '<Ignore>'
        end, {expr = true})

        -- Actions
        map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
        map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
        map('n', '<leader>hS', gs.stage_buffer)
        map('n', '<leader>hu', gs.undo_stage_hunk)
        map('n', '<leader>hR', gs.reset_buffer)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hb', function() gs.blame_line {full = true} end)
        map('n', '<leader>hd', function() gs.diffthis() end)
        map('n', '<leader>hD', function() gs.diffthis('~') end)
        map('n', '<leader>ho', gs.toggle_deleted)
    end
})
