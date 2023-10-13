return {
  'stevearc/oil.nvim',
  opts = {},
  config = function()
    require("oil").setup()

    local c = require("common")
    c.kmap("n", "-", "<cmd>Oil<cr>")
  end,
}
