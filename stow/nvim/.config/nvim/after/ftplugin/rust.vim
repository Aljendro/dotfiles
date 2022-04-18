set shiftwidth=4
set softtabstop=4
set tabstop=4

cnoreabbrev <expr> cb CommandAbbreviation('cb', 'call VimuxRunCommand("cargo build")')
cnoreabbrev <expr> cbr CommandAbbreviation('cbr', 'call VimuxRunCommand("cargo build --release")')
cnoreabbrev <expr> cr CommandAbbreviation('cr', 'call VimuxRunCommand("cargo run")')
cnoreabbrev <expr> crr CommandAbbreviation('crr', 'call VimuxRunCommand("cargo run --release")')
