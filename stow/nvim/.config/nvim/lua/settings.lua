vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.node_host_prog = vim.fn.expand("~/.nvm/versions/node/v16.20.0/bin/neovim-node-host")
vim.g.python3_host_prog = vim.fn.expand("/usr/bin/python3")
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1

vim.o.termguicolors = true

vim.opt.dictionary:append("/usr/share/dict/words")
vim.opt.iskeyword:append("-")
vim.opt.shortmess:append("c")

vim.opt.clipboard = { "unnamed" }
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.cursorline = true
vim.opt.display = { "truncate" }
vim.opt.expandtab = true
vim.opt.fillchars = { diff = " ", fold = "." }
vim.opt.foldlevel = 99
vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
vim.opt.grepprg = "rg --vimgrep --no-heading"
vim.opt.ignorecase = true
vim.opt.list = true
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmode = false
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.updatetime = 100
vim.opt.virtualedit = { "block", "onemore" }
vim.opt.wrap = false
vim.opt.writebackup = false

vim.cmd([[
let g:copilot_no_tab_map = v:true
let g:VM_theme = "neon"
let g:VM_silent_exit = v:true
let g:VM_leader = "<bslash>"
let g:VM_mouse_mappings = v:true
]])
