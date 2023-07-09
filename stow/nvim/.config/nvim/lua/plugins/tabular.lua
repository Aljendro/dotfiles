return {
    "godlygeek/tabular",
    cmd = { "Tabularize" },
    config = function()
        vim.cmd([[

        :AddTabularPattern! 1, /^[^,]*\zs,/l0c0l0
        :AddTabularPattern! 1: /^[^:]*\zs:/l0c1l0
        :AddTabularPipeline! sp /\s\{1,}/
              \ map(a:lines, "substitute(v:val, '\s\{1,}', ' ', 'g')")
              \   | tabular#TabularizeStrings(a:lines, ' ', 'l0')

        ]])
    end,
}
