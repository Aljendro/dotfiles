set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" Reflow bases on column length
nnoremap <leader>fm vapgq

nnoremap <C-f> :MarkdownPreviewToggle<cr>


lua << EOF

function _G.toggleListItem(character)
        local cursor_row = unpack(vim.api.nvim_win_get_cursor(0))
        local cursor_row = cursor_row - 1
        local line_contents = vim.api.nvim_get_current_line()
        local star_position = string.find(line_contents, "*")

        if star_position then
                local check_position = string.find(line_contents, character)
                local offset = string.len(character) + 2
                local replacement = {}
                if (star_position + 2) ~= check_position then
                        offset = 1
                        replacement = {character .. " "}
                end
                vim.api.nvim_buf_set_text(0, cursor_row, star_position + 1, cursor_row, star_position + offset, replacement)
        end
end

EOF

nnoremap <silent> <leader><leader>c :lua toggleListItem("✅")<cr>
nnoremap <silent> <leader><leader>p :lua toggleListItem("🚧")<cr>
