return {
  "karb94/neoscroll.nvim",
  -- stylua: ignore
  keys = {
    { "<C-k>", mode = { "n", "v" }, function() require("neoscroll").ctrl_u({ duration = 200 }) end },
    { "<C-j>", mode = { "n", "v" }, function() require("neoscroll").ctrl_d({ duration = 200 }) end },
    { "<PageUp>", mode = { "n", "v" }, function() require("neoscroll").ctrl_b({ duration = 250 }) end },
    { "<PageDown>", mode = { "n", "v" }, function() require("neoscroll").ctrl_f({ duration = 250 }) end },
    { "<Up>", mode = { "n", "v" }, function() require("neoscroll").scroll(-0.2, { move_cursor = false, duration = 100 }) end },
    { "<Down>", mode = { "n", "v" }, function() require("neoscroll").scroll(0.2, { move_cursor = false, duration = 100 }) end },
  }
}
