-- Neovim init settings
--
-- Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
--

require('aljendro/config/plugins/packer');
require('aljendro/config/functions');
require('aljendro/config/core');

-- Enable Aniseed's automatic compilation and loading of Fennel source code.
vim.g["aniseed#env"] = {
  module = "dotfiles.init",
  compile = true
}

