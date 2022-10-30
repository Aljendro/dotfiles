set shiftwidth=4
set softtabstop=4
set tabstop=4

cnoreabbrev <expr> cb v:lua.CommandAbbreviation('cb', 'call VimuxRunCommand("cargo build")')
cnoreabbrev <expr> cbr v:lua.CommandAbbreviation('cbr', 'call VimuxRunCommand("cargo build --release")')
cnoreabbrev <expr> cr v:lua.CommandAbbreviation('cr', 'call VimuxRunCommand("cargo run")')
cnoreabbrev <expr> crr v:lua.CommandAbbreviation('crr', 'call VimuxRunCommand("cargo run --release")')
