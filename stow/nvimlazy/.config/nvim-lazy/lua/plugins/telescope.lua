return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-telescope/telescope-live-grep-args.nvim",
    {
      "AckslD/nvim-neoclip.lua",
      enabled = true,
      config = function()
        require("neoclip").setup({ default_register = { '"', "+", "*" } })
      end,
    },
  },
  keys = {
    {
      ";b",
      "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
      desc = "Switch Buffer",
    },
    {
      ";gg",
      ":lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>",
      desc = "Grep (Root Dir)",
    },
    { ";B", ":lua require('telescope.builtin').builtin()<cr>" },
    { ";;", "<cmd>Telescope command_history<cr>", mode = { "n", "v" }, desc = "Command History" },
    { ";/", "<cmd>Telescope search_history<cr>", desc = "Command History" },
    { ";f", ":lua require('telescope.builtin').find_files({hidden = true})<cr>" },
    { ";c", LazyVim.pick.config_files(), desc = "Find Config File" },
    { ";of", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
    {
      ";gc",
      ':lua require(\'telescope.builtin\').git_bcommits({layout_strategy=\'vertical\', git_command = {"git","log","--format=%h %cn %cs %s"} })<cr>',
      desc = "Buffer Commits",
    },
    {
      ";gc",
      ':lua require(\'telescope.builtin\').git_bcommits_range({layout_strategy=\'vertical\', git_command = {"git","log","--format=%h %cn %cs %s", "--no-patch", "-L"} })<cr>',
      mode = { "x" },
      desc = "Buffer Commits (Range)",
    },
    { ";gC", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
    { ";gs", ":lua require('telescope.builtin').git_status({layout_strategy='vertical'})<cr>" },
    { ";gb", ":lua require('telescope.builtin').git_branches()<cr>" },
    { ";gS", ":lua require('telescope.builtin').git_stash()<cr>" },
    { ";R", "<cmd>Telescope registers<cr>", desc = "Registers" },
    { ";a", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
    {
      ";s",
      ":lua require('telescope.builtin').current_buffer_fuzzy_find({skip_empty_lines=true})<cr>",
      desc = "Search Buffer",
    },
    { ";C", "<cmd>Telescope commands<cr>", desc = "Commands" },
    { ";ld", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
    { ";lD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
    { ";h", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
    { ";j", ":lua require('telescope.builtin').jumplist({ignore_filename=false})<cr>" },
    { ";k", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
    { ";n", ":lua require('telescope').extensions.neoclip.default()<cr>" },
    { ";p", ":lua require('telescope.builtin').pickers()<cr>" },
    { ";ll", "<cmd>Telescope loclist<cr>", desc = "Location List" },
    { ";m", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
    { ";M", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
    { ";vo", "<cmd>Telescope vim_options<cr>", desc = "Options" },
    { ";r", "<cmd>Telescope resume<cr>", desc = "Resume" },
    { ";q", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
    { ";S", ":lua require('telescope.builtin').spell_suggest()<cr>" },
    { ";t", ":lua require('telescope.builtin').treesitter()<cr>" },
    { ";vf", ":lua require('telescope.builtin').filetypes()<cr>" },
    {
      ";gf",
      ":lua require('telescope.builtin').grep_string({ shorten_path = true, word_match = '-w', only_sort_text = true, search = '' })<cr>",
    },
    {
      ";gF",
      ":lua require('telescope.builtin').grep_string({ shorten_path = true, word_match = '-w', only_sort_text = false, search = '' })<cr>",
    },
    { ";w", LazyVim.pick("grep_string", { word_match = "-w" }), desc = "Word (Root Dir)" },
    { ";W", LazyVim.pick("grep_string", { root = false, word_match = "-w" }), desc = "Word (cwd)" },
    { ";w", LazyVim.pick("grep_string"), mode = "v", desc = "Selection (Root Dir)" },
    { ";W", LazyVim.pick("grep_string", { root = false }), mode = "v", desc = "Selection (cwd)" },
    {
      ";ls",
      function()
        require("telescope.builtin").lsp_document_symbols({
          symbols = LazyVim.config.get_kind_filter(),
        })
      end,
      desc = "Goto Symbol",
    },
    {
      ";lS",
      function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols({
          symbols = LazyVim.config.get_kind_filter(),
        })
      end,
      desc = "Goto Symbol (Workspace)",
    },
  },
  opts = function()
    local actions = require("telescope.actions")

    local open_with_trouble = function(...)
      return require("trouble.sources.telescope").open(...)
    end
    local find_files_no_ignore = function()
      local action_state = require("telescope.actions.state")
      local line = action_state.get_current_line()
      LazyVim.pick("find_files", { no_ignore = true, default_text = line })()
    end
    local find_files_with_hidden = function()
      local action_state = require("telescope.actions.state")
      local line = action_state.get_current_line()
      LazyVim.pick("find_files", { hidden = true, default_text = line })()
    end

    local function find_command()
      if 1 == vim.fn.executable("rg") then
        return { "rg", "--files", "--color", "never", "-g", "!.git" }
      elseif 1 == vim.fn.executable("fd") then
        return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
      elseif 1 == vim.fn.executable("fdfind") then
        return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
      elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
        return { "find", ".", "-type", "f" }
      elseif 1 == vim.fn.executable("where") then
        return { "where", "/r", ".", "*" }
      end
    end

    return {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        -- open files in the first window that is an actual file.
        -- use the current window if no other window is available.
        get_selection_window = function()
          local wins = vim.api.nvim_list_wins()
          table.insert(wins, 1, vim.api.nvim_get_current_win())
          for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].buftype == "" then
              return win
            end
          end
          return 0
        end,
        cache_picker = { num_pickers = 20 },
        layout_strategy = "flex",
        layout_config = {
          height = 0.99,
          width = 0.99,
          horizontal = { preview_width = 0.5 },
          vertical = { preview_height = 0.55 },
        },
        mappings = {
          i = {
            ["<c-t>"] = open_with_trouble,
            ["<a-t>"] = open_with_trouble,
            ["<a-i>"] = find_files_no_ignore,
            ["<a-h>"] = find_files_with_hidden,
            ["<C-Down>"] = actions.cycle_history_next,
            ["<C-Up>"] = actions.cycle_history_prev,
            ["<C-f>"] = actions.preview_scrolling_down,
            ["<C-b>"] = actions.preview_scrolling_up,
            ["<C-j>"] = require("telescope.actions").move_selection_next,
            ["<C-k>"] = require("telescope.actions").move_selection_previous,
          },
          n = {
            ["q"] = actions.close,
            ["<C-j>"] = require("telescope.actions").move_selection_next,
            ["<C-k>"] = require("telescope.actions").move_selection_previous,
          },
        },
      },
      pickers = {
        find_files = {
          find_command = find_command,
          hidden = true,
        },
      },
      extensions = {
        live_grep_args = {
          auto_quoting = true, -- enable/disable auto-quoting
          -- define mappings, e.g.
          mappings = { -- extend mappings
            i = {
              ["<C-h>"] = require("telescope-live-grep-args.actions").quote_prompt({ postfix = " -g " }),
              ["<C-n>"] = require("telescope-live-grep-args.actions").quote_prompt({
                postfix = " -U --multiline-dotall ",
              }),
            },
          },
        },
      },
    }
  end,
}
