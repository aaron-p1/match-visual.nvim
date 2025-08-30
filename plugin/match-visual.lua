local mv = require("match-visual")

local group = vim.api.nvim_create_augroup("MatchVisual", { clear = true })

vim.api.nvim_create_autocmd("CursorMoved", { group = group, callback = mv.match_visual })
vim.api.nvim_create_autocmd("ModeChanged",
  { group = group, pattern = "*:[vV]", callback = function() vim.schedule(mv.match_visual) end })
vim.api.nvim_create_autocmd("ModeChanged",
  { group = group, pattern = "[vV]:*", callback = mv.remove_visual_selection })
