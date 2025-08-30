local mv = require("match-visual")

local group = vim.api.nvim_create_augroup("MatchVisual", { clear = true })

local ns = vim.api.nvim_create_namespace("MatchVisual")

local prev_cursor = {}
local prev_other_end = {}

-- Unfortunately there is no way to detect a change in the visual selection range, if the cursor
-- does not move. So we have to listen to all key presses, and check if the selection changed.
-- To avoid too many calls, it is run at most once per event loop.
local scheduled = false
local function schedule_match_on_selection_change()
  if scheduled then
    return
  end
  scheduled = true

  vim.schedule(function()
    scheduled = false
    local cursor = vim.fn.getpos(".")
    local other = vim.fn.getpos("v")

    -- if selection hasn't changed, don't match again
    if vim.deep_equal(prev_cursor, cursor) and vim.deep_equal(prev_other_end, other) then
      return
    end

    -- if cursor just goes to other end of selection without changing it, don't match again
    if vim.deep_equal(prev_other_end, cursor) and vim.deep_equal(prev_cursor, other) then
      return
    end

    mv.match_visual()

    prev_cursor = cursor
    prev_other_end = other
  end)
end

local function start_visual_mode()
  vim.schedule(mv.match_visual)

  prev_cursor = vim.fn.getpos(".")
  prev_other_end = vim.fn.getpos("v")
  vim.on_key(schedule_match_on_selection_change, ns)
end

local function end_visual_mode()
  vim.on_key(nil, ns)
  mv.remove_matches()
end

vim.api.nvim_create_autocmd("ModeChanged",
  { group = group, pattern = "*:[vV]", callback = start_visual_mode })
vim.api.nvim_create_autocmd("ModeChanged",
  { group = group, pattern = "[vV]:*", callback = end_visual_mode })
