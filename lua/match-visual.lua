--- @class MatchVisualConfig
--- @field min_length integer Minimum length of selection needed for highlighting
--- @field hl_group string Highlight group to use for highlighting

--- @type MatchVisualConfig
local config = { min_length = 1, hl_group = "Visual" }

local HL_GROUP = "VisualMatch"

-- Link configured highlight group to the new group
vim.api.nvim_set_hl(0, HL_GROUP, { default = true, link = config.hl_group })

--- @alias SavedMatch { match_id: integer, win_id: integer }

--- @type SavedMatch[]
local saved_matches = {}

local M = {}

--- Convert lines to a plain text search pattern
--- @param lines string[]
--- @return string?
local function lines_to_match_string(lines)
  local escaped_lines = vim.tbl_map(function(s) return vim.fn.escape(s, "\\") end, lines)
  local text = table.concat(escaped_lines, "\\n")
  return text == "" and nil or "\\V" .. text
end

--- Removes all saved matches
function M.remove_matches()
  for _, match in ipairs(saved_matches) do
    pcall(vim.fn.matchdelete, match.match_id, match.win_id)
  end
  saved_matches = {}
end

-- deprecated name
M.remove_visual_selection = M.remove_matches

--- Add matches (highlighted patterns) to all windows in the current tabpage based on text between
--- start_pos and end_pos in the current buffer.
--- @params string[] lines lines of text to convert to matches
local function add_matches(lines)
  M.remove_matches()
  -- calculate the length of raw input because escaping may add extra characters
  local match_length = #table.concat(lines, " ")
  local match_string = lines_to_match_string(lines)

  if not match_string or match_length < config.min_length then
    return
  end

  local wins = vim.api.nvim_tabpage_list_wins(0)
  for _, win_id in ipairs(wins) do
    local match_id = vim.fn.matchadd(HL_GROUP, match_string, 100, -1, { window = win_id })
    if match_id ~= -1 then
      table.insert(saved_matches, { match_id = match_id, win_id = win_id })
    end
  end
end

--- Returns start and end positions of visual selection. 0-indexed.
--- @return integer[] Start position
--- @return integer[] End position
local function current_selection_range()
  local cursor = vim.fn.getpos(".")
  local other = vim.fn.getpos("v")
  local srow, scol = other[2] - 1, math.max(other[3] - 1, 0)
  local erow, ecol = cursor[2] - 1, math.max(cursor[3] - 1, 0)
  if (erow < srow) or (erow == srow and ecol < scol) then
    srow, erow = erow, srow
    scol, ecol = ecol, scol
  end
  return { srow, scol }, { erow, ecol }
end


--- Highlights the visual selection in all windows in the current tabpage.
function M.match_visual()
  local mode = vim.fn.mode()
  if not vim.tbl_contains({ "v", "V" }, mode) then
    return
  end

  local start_pos, end_pos = current_selection_range()
  local lines = mode == "V"
      and vim.api.nvim_buf_get_lines(0, start_pos[1], end_pos[1] + 1, false)
      or vim.api.nvim_buf_get_text(0, start_pos[1], start_pos[2], end_pos[1], end_pos[2] + 1, {})

  add_matches(lines)
end

--- Configure the plugin
--- @param user_config MatchVisualConfig
function M.setup(user_config)
  user_config = user_config or {}
  if user_config.min_length then
    config.min_length = user_config.min_length
  end
  if user_config.hl_group then
    config.hl_group = user_config.hl_group
    vim.api.nvim_set_hl(0, HL_GROUP, { link = config.hl_group })
  end
end

return M
