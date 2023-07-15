-- Neovim init settings
--
-- Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
--
-- Install Lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("settings")
require("functions")
require("keybindings")
require("autocommands")

require("lazy").setup(
    "plugins",
    { change_detection = { notify = false } }
)
