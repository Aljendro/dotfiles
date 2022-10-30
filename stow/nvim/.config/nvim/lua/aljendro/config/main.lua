-- Neovim init settings
--
-- Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
--
require('aljendro/config/plugins/packer');

require('tokyonight').setup({dim_inactive = true})

require('aljendro/config/functions');
vim.cmd('source $HOME/.config/nvim/config/core.vim')

