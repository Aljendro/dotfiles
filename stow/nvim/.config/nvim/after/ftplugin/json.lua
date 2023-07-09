vim.cmd("cnoreabbrev <buffer> <expr> jq v:lua.CommandAbbreviation('jq', '%!jq ', '!jq ')")
vim.cmd("cnoreabbrev <buffer> <expr> jqc v:lua.CommandAbbreviation('jqc', '%!jq -c ', '!jq -c ')")
vim.cmd("cnoreabbrev <buffer> <expr> jqs v:lua.CommandAbbreviation('jqs', '%!jq -s ', '!jq -s ')")
vim.cmd("cnoreabbrev <buffer> <expr> jqcs v:lua.CommandAbbreviation('jqcs', '%!jq -c -s ', '!jq -c -s ')")

