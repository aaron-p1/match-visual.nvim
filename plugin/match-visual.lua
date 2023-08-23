 local _local_1_ = vim local _local_2_ = _local_1_["api"] local nvim_create_autocmd = _local_2_["nvim_create_autocmd"] local nvim_create_augroup = _local_2_["nvim_create_augroup"] local schedule = _local_1_["schedule"]

 local _local_3_ = require("match-visual") local match_visual = _local_3_["match_visual"] local remove_visual_selection = _local_3_["remove_visual_selection"]

 local group = nvim_create_augroup("MatchVisual", {clear = true})
 nvim_create_autocmd("CursorMoved", {group = group, callback = match_visual})



 local function _4_() return schedule(match_visual) end nvim_create_autocmd("ModeChanged", {group = group, pattern = "*:[vV]", callback = _4_})
 return nvim_create_autocmd("ModeChanged", {group = group, pattern = "[vV]:*", callback = remove_visual_selection})
