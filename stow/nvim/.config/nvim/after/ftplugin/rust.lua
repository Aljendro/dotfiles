vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4

vim.cmd([[

cnoreabbrev <expr> cb v:lua.CommandAbbreviation('cb', 'call VimuxRunCommand("cargo build")')
cnoreabbrev <expr> cbr v:lua.CommandAbbreviation('cbr', 'call VimuxRunCommand("cargo build --release")')
cnoreabbrev <expr> cr v:lua.CommandAbbreviation('cr', 'call VimuxRunCommand("cargo run")')
cnoreabbrev <expr> crr v:lua.CommandAbbreviation('crr', 'call VimuxRunCommand("cargo run --release")')

]])
