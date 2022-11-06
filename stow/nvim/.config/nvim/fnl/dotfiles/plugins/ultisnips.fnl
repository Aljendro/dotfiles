(module dotfiles.plugins.ultisnips)

(set vim.g.UltiSnipsRemoveSelectModeMappings false)
(set vim.g.snippetPath (.. (os.getenv "HOME") "/.config/nvim/ultisnips"))
(set vim.g.UltiSnipsSnippetDirectories [vim.g.snippetPath])

