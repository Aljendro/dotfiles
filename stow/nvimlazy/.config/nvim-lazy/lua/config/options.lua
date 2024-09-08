-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.formatoptions = "jcqlnt"
opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
opt.grepprg = "rg --vimgrep --no-heading"
opt.scrolloff = 0
opt.swapfile = false
opt.timeoutlen = 1000
opt.virtualedit = { "block", "onemore" }
