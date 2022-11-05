vim.cmd([[

cnoreabbrev <expr> jq v:lua.CommandAbbreviation('jq', "%!jq ''<left>", "!jq ''<left>")
cnoreabbrev <expr> jqc v:lua.CommandAbbreviation('jqc', "%!jq -c ''<left>", "!jq -c ''<left>")
cnoreabbrev <expr> jqs v:lua.CommandAbbreviation('jqs', "%!jq -s ''<left>", "!jq -s ''<left>")
cnoreabbrev <expr> jqs v:lua.CommandAbbreviation('jqcs', "%!jq -c -s ''<left>", "!jq -c -s ''<left>")

]])
