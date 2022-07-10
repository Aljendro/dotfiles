require('telescope').setup({
    defaults = {
        cache_picker = {num_pickers = 20},
        layout_strategy = 'flex',
        layout_config = {
            height = 0.95,
            width = 0.95,
            vertical = {preview_height = 0.45},
            horizontal = {preview_width = 0.50}
        }
    }
})
require('telescope').load_extension('fzf')
