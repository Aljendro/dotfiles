return {
  'stevearc/oil.nvim',
  opts = {},
  config = function()
    require("oil").setup({
      columns = {
        "permissions",
        "size",
        { "mtime", format = "%Y-%m-%d %X" },
        { "icon",  add_padding = false },
      },
      view_options = {
        show_hidden = true,
      },
    })

    local c = require("common")
    c.kmap("n", "-", "<cmd>Oil<cr>")
  end,
}
