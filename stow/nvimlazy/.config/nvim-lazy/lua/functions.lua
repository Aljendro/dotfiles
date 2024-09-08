-- Helper functions
--
-- Maintainer: Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>
--
-- Pretty print

local c = require("common")

function Put(...)
  local objects = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, "\n"))
  return ...
end

function DeleteTrailingSpaces()
  local search_register_value = vim.fn.getreg("/")
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.histdel("search", -1)
  vim.fn.setreg("/", search_register_value)
end

function GetSelectedText()
  local saved_reg = vim.fn.getreg('"')
  vim.cmd([[execute "normal! vgvy"]])
  vim.fn.setreg("/", vim.fn.escape(vim.fn.getreg('"'), "\\/.*'$^~[]"))
  vim.fn.setreg('"', saved_reg)
end

function GetSelectedTextGrep()
  local saved_reg = vim.fn.getreg('"')
  vim.cmd([[execute "normal! vgvy"]])
  vim.fn.setreg("/", vim.fn.escape(vim.fn.getreg('"'), " "))
  vim.fn.setreg('"', saved_reg)
end

function MakeSession(session_name)
  local session_dir = os.getenv("HOME") .. "/.config/nvim/sessions/"

  if vim.fn.filewritable(session_dir) ~= 2 then
    os.execute("mkdir -p " .. session_dir)
  end

  if session_name == "" or session_name == nil then
    session_name = vim.fn.input("Save session name: ")
  end

  local filename = session_dir .. "session-" .. session_name .. ".vim"
  vim.cmd([[execute 'mksession! ]] .. filename .. "'")
end

function LoadSession(session_name)
  local session_dir = os.getenv("HOME") .. "/.config/nvim/sessions/"

  if session_name == "" or session_name == nil then
    session_name = vim.fn.input("Load session name: ")
  end

  local filename = session_dir .. "session-" .. session_name .. ".vim"
  if vim.fn.filereadable(filename) then
    vim.cmd([[source ]] .. filename)
  else
    print("No Session loaded.")
  end
end

function RecordMacro()
  print("Register: ")
  local register = vim.fn.nr2char(vim.fn.getchar())
  -- Clear out the register and start recording
  vim.cmd([[execute 'normal! q]] .. register .. "qq" .. register .. "'")
end

local function setRegister()
  print("Register: ")
  local register = vim.fn.toupper(vim.fn.nr2char(vim.fn.getchar()))
  vim.cmd("execute ':let @" .. register .. "=" .. [["\<C-j>"']])
  vim.cmd("redraw")
end

function AppendNewlineToRegister()
  if pcall(setRegister) then
    print("Appended newline to register")
  else
    print("Unable to append newline to register")
  end
end

function EatChar(pattern)
  local character = vim.fn.nr2char(vim.fn.getchar(0))
  local parsed_regex = vim.regex(pattern)
  if parsed_regex:match_str(character) then
    return ""
  else
    return character
  end
end

function CommandAbbreviation(abbreviation, substitution, range_substitution)
  if vim.fn.getcmdtype() == ":" then
    -- Do not place EatChar here, it will always EatChar in command mode
    -- and you need to press <cr> twice when typing
    local parsed_start_regex = vim.regex("^" .. abbreviation)
    local parse_visual_start_regex = vim.regex("^'<,'>" .. abbreviation)
    local cmd_line_string = vim.fn.getcmdline()
    if parsed_start_regex:match_str(cmd_line_string) then
      EatChar([[\s]])
      return substitution
    elseif parse_visual_start_regex:match_str(cmd_line_string) then
      EatChar([[\s]])
      if range_substitution then
        return range_substitution
      else
        return substitution
      end
    end
  end
  return abbreviation
end

function BToggle(name, message)
  vim.b[name] = not vim.b[name]
  local trueFalseStr = vim.b[name] and "true" or "false"
  print(message .. trueFalseStr)
  return vim.b[name]
end

function TToggle(name, message)
  vim.t[name] = not vim.t[name]
  local trueFalseStr = vim.t[name] and "true" or "false"
  print(message .. trueFalseStr)
  return vim.t[name]
end

function ToggleOff(name, message)
  vim.b[name] = false
  print(message .. "false")
  return vim.b[name]
end

function DiffContext(reverse)
  local searchOption
  if reverse then
    searchOption = "bW"
  else
    searchOption = "W"
  end
  vim.fn.search([[^\(@@ .* @@\|[<=>|]\{7}[<=>|]\@!\)]], searchOption)
  vim.cmd([[execute "normal! zz"]])
end

function ToggleListItem(character)
  local cursor_row = unpack(vim.api.nvim_win_get_cursor(0))
  cursor_row = cursor_row - 1
  local line_contents = vim.api.nvim_get_current_line()
  local list_item_char_position = string.find(line_contents, "[%*%-]")

  if list_item_char_position then
    local check_position = string.find(line_contents, character)
    local offset = string.len(character) + 2
    local replacement = {}
    if (list_item_char_position + 2) ~= check_position then
      offset = 1
      replacement = { character .. " " }
    end
    vim.api.nvim_buf_set_text(
      0,
      cursor_row,
      list_item_char_position + 1,
      cursor_row,
      list_item_char_position + offset,
      replacement
    )
  end
end
