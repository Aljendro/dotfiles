(module dotfiles.core.settings)

(set vim.g.loaded_perl_provider 0)
(set vim.g.loaded_ruby_provider 0)
(set vim.g.node_host_prog (vim.fn.expand "~/.nvm/versions/node/v16.18.1/bin/neovim-node-host"))
(set vim.g.python3_host_prog (vim.fn.expand "/usr/bin/python3"))
(set vim.g.loaded_netrwPlugin 0)
(set vim.g.loaded_tutor_mode_plugin 0)

(vim.opt.dictionary:append "/usr/share/dict/words")
(vim.opt.iskeyword:append "-")
(vim.opt.shortmess:append "c")

(set vim.opt.clipboard [:unnamed])
(set vim.opt.completeopt [:menu :menuone :noselect])
(set vim.opt.cursorline true)
(set vim.opt.display [:truncate])
(set vim.opt.expandtab true)
(set vim.opt.fillchars {:diff " " :fold "."})
(set vim.opt.foldlevel 99)
(set vim.opt.grepformat "%f:%l:%c:%m,%f:%l:%m")
(set vim.opt.grepprg "rg --vimgrep --no-heading")
(set vim.opt.ignorecase true)
(set vim.opt.list true)
(set vim.opt.mouse "a")
(set vim.opt.number true)
(set vim.opt.relativenumber true)
(set vim.opt.showmode false)
(set vim.opt.showtabline 2)
(set vim.opt.signcolumn "yes")
(set vim.opt.smartcase true)
(set vim.opt.smartindent true)
(set vim.opt.splitbelow true)
(set vim.opt.splitright true)
(set vim.opt.swapfile false)
(set vim.opt.updatetime 100)
(set vim.opt.virtualedit [:block :onemore])
(set vim.opt.wrap false)
(set vim.opt.writebackup false)

