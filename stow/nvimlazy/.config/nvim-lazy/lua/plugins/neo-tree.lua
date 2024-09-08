return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    {
      ";dd",
      function()
        require("neo-tree.command").execute({ toggle = true, reveal = true, dir = LazyVim.root() })
      end,
      desc = "Explorer NeoTree (Root Dir)",
    },
  },
}
