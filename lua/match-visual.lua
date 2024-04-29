 local _local_1_ = vim local tbl_map = _local_1_["tbl_map"]
 local tbl_contains = _local_1_["tbl_contains"]
 local tbl_extend = _local_1_["tbl_extend"]
 local _local_2_ = _local_1_["api"] local nvim_set_hl = _local_2_["nvim_set_hl"]
 local nvim_buf_get_lines = _local_2_["nvim_buf_get_lines"]
 local nvim_buf_get_text = _local_2_["nvim_buf_get_text"]
 local nvim_tabpage_list_wins = _local_2_["nvim_tabpage_list_wins"]
 local nvim_win_get_cursor = _local_2_["nvim_win_get_cursor"]
 local nvim_create_augroup = _local_2_["nvim_create_augroup"]
 local nvim_create_autocmd = _local_2_["nvim_create_autocmd"]
 local _local_3_ = _local_1_["fn"] local join = _local_3_["join"] local escape = _local_3_["escape"] local matchadd = _local_3_["matchadd"] local matchdelete = _local_3_["matchdelete"] local mode = _local_3_["mode"] local getpos = _local_3_["getpos"]


 local default_config = {min_length = 1, hl_group = "Visual", match_id = 118} local highlight_group = "VisualMatch"


 nvim_set_hl(0, highlight_group, {default = true, link = default_config.hl_group})

 local min_length = default_config.min_length
 local visual_matches = {}

 local function lines__3ematch_string(lines) _G.assert((nil ~= lines), "Missing argument lines on fennel/src/match-visual.fnl:22")
 local escaped_lines local function _4_(_241) return escape(_241, "\\") end escaped_lines = tbl_map(_4_, lines)
 local text = join(escaped_lines, "\\n")
 if (0 ~= #text) then
 return ("\\V" .. text) else return nil end end

 local function add_matches(group, line_wise_3f, _6_, _8_) local _arg_7_ = _6_ local start_row = _arg_7_[1] local start_col = _arg_7_[2] local _arg_9_ = _8_ local end_row = _arg_9_[1] local end_col = _arg_9_[2] _G.assert((nil ~= end_col), "Missing argument end-col on fennel/src/match-visual.fnl:28") _G.assert((nil ~= end_row), "Missing argument end-row on fennel/src/match-visual.fnl:28") _G.assert((nil ~= start_col), "Missing argument start-col on fennel/src/match-visual.fnl:28") _G.assert((nil ~= start_row), "Missing argument start-row on fennel/src/match-visual.fnl:28") _G.assert((nil ~= line_wise_3f), "Missing argument line-wise? on fennel/src/match-visual.fnl:28") _G.assert((nil ~= group), "Missing argument group on fennel/src/match-visual.fnl:28")
 local lines if line_wise_3f then
 lines = nvim_buf_get_lines(0, start_row, (1 + end_row), false) else
 lines = nvim_buf_get_text(0, start_row, start_col, end_row, (1 + end_col), {}) end

 local match_length = #join(lines, " ")
 local _3fmatch_string = lines__3ematch_string(lines)
 if (_3fmatch_string and (match_length >= min_length)) then
 local wins = nvim_tabpage_list_wins(0) local tbl_17_auto = {}
 local i_18_auto = #tbl_17_auto for _, win_id in ipairs(wins) do local val_19_auto
 do local match_id = matchadd(group, _3fmatch_string, 100, -1, {window = win_id})
 val_19_auto = {match_id, win_id} end if (nil ~= val_19_auto) then i_18_auto = (i_18_auto + 1) do end (tbl_17_auto)[i_18_auto] = val_19_auto else end end return tbl_17_auto else return nil end end

 local function remove_visual_selection()
 for _, _13_ in ipairs(visual_matches) do local _each_14_ = _13_ local match_id = _each_14_[1] local win_id = _each_14_[2]
 if (-1 ~= match_id) then pcall(matchdelete, match_id, win_id) else end end
 visual_matches = {} return nil end

 local function order_positions(_16_, _18_) local _arg_17_ = _16_ local start_row = _arg_17_[1] local start_col = _arg_17_[2] local _arg_19_ = _18_ local end_row = _arg_19_[1] local end_col = _arg_19_[2] _G.assert((nil ~= end_col), "Missing argument end-col on fennel/src/match-visual.fnl:46") _G.assert((nil ~= end_row), "Missing argument end-row on fennel/src/match-visual.fnl:46") _G.assert((nil ~= start_col), "Missing argument start-col on fennel/src/match-visual.fnl:46") _G.assert((nil ~= start_row), "Missing argument start-row on fennel/src/match-visual.fnl:46")
 if ((start_row > end_row) or ((start_row == end_row) and (start_col > end_col))) then

 return {end_row, end_col}, {start_row, start_col} else
 return {start_row, start_col}, {end_row, end_col} end end

 local function get_range(line_wise_3f) _G.assert((nil ~= line_wise_3f), "Missing argument line-wise? on fennel/src/match-visual.fnl:52")
 local _let_21_ = getpos("v") local _ = _let_21_[1] local visual_row = _let_21_[2] local visual_col = _let_21_[3]
 local _let_22_ = nvim_win_get_cursor(0) local cursor_row = _let_22_[1] local cursor_col = _let_22_[2]
 local v_row0 = (visual_row - 1)
 local v_col0 = (visual_col - 1)
 local c_row0 = (cursor_row - 1) local visual_pos
 if line_wise_3f then visual_pos = {v_row0, 0} else visual_pos = {v_row0, v_col0} end local cursor_pos
 if line_wise_3f then cursor_pos = {c_row0, 0} else cursor_pos = {c_row0, cursor_col} end
 return order_positions(visual_pos, cursor_pos) end

 local function match_visual()
 remove_visual_selection()
 local mode0 = mode()
 if tbl_contains({"v", "V"}, mode0) then
 local line_wise_3f = (mode0 == "V")
 local _3fmatches = add_matches(highlight_group, line_wise_3f, get_range(line_wise_3f))

 visual_matches = (_3fmatches or {}) return nil else return nil end end

 local function setup(_3fuser_config)
 local user_config = (_3fuser_config or {})
 if user_config.min_length then
 min_length = user_config.min_length else end
 if user_config.hl_group then
 return nvim_set_hl(0, highlight_group, {link = user_config.hl_group}) else return nil end end

 return {setup = setup, match_visual = match_visual, remove_visual_selection = remove_visual_selection}
