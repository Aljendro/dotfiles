(module dotfiles.plugins.harpoon
  {autoload {{: kmap} dotfiles.core.common}})

(kmap :n "<leader>sa" ":lua require('harpoon.mark').add_file()<cr>")
(kmap :n "<leader>sA" ":lua require('harpoon.ui').toggle_quick_menu()<cr>")
(kmap :n "<leader>sm" ":lua require('harpoon.ui').nav_file(1)<cr>")
(kmap :n "<leader>s," ":lua require('harpoon.ui').nav_file(2)<cr>")
(kmap :n "<leader>s." ":lua require('harpoon.ui').nav_file(3)<cr>")
(kmap :n "<leader>sj" ":lua require('harpoon.ui').nav_file(4)<cr>")
(kmap :n "<leader>sk" ":lua require('harpoon.ui').nav_file(5)<cr>")
(kmap :n "<leader>sl" ":lua require('harpoon.ui').nav_file(6)<cr>")
(kmap :n "<leader>su" ":lua require('harpoon.ui').nav_file(7)<cr>")
(kmap :n "<leader>si" ":lua require('harpoon.ui').nav_file(8)<cr>")
(kmap :n "<leader>so" ":lua require('harpoon.ui').nav_file(9)<cr>")

