(local {: tbl_map
        : tbl_contains
        : tbl_extend
        :api {: nvim_set_hl
              : nvim_buf_get_lines
              : nvim_buf_get_text
              : nvim_tabpage_list_wins
              : nvim_win_get_cursor
              : nvim_create_augroup
              : nvim_create_autocmd}
        :fn {: join : escape : matchadd : matchdelete : mode : getpos}}
       vim)

(local default-config {:match_id 118 :hl_group :Visual})

(local highlight-group :VisualMatch)
(nvim_set_hl 0 highlight-group {:default true :link default-config.hl_group})

(var default-match-id default-config.match_id)
(var visual-matches [])

(lambda set-default-match-id [id]
  (set default-match-id id))

(lambda lines->match-string [lines]
  (let [escaped-lines (tbl_map #(escape $1 "\\") lines)
        text (join escaped-lines "\\n")]
    (if (not= 0 (length text))
        (.. "\\V" text))))

(lambda add-matches [group line-wise? [start-row start-col] [end-row end-col]]
  (let [lines (if line-wise?
                  (nvim_buf_get_lines 0 start-row (+ 1 end-row) false)
                  (nvim_buf_get_text 0 start-row start-col end-row
                                     (+ 1 end-col) {}))
        match-string (lines->match-string lines)]
    (when match-string
      (let [wins (nvim_tabpage_list_wins 0)]
        (icollect [_ win-id (ipairs wins)]
          (let [match-id (matchadd group match-string 10 default-match-id
                                   {:window win-id})]
            [match-id win-id]))))))

(lambda remove-visual-selection []
  (each [_ [match-id win-id] (ipairs visual-matches)]
    (if (not= -1 match-id) (matchdelete match-id win-id)))
  (set visual-matches []))

(lambda order-positions [[start-row start-col] [end-row end-col]]
  (if (or (> start-row end-row)
          (and (= start-row end-row) (> start-col end-col)))
      (values [end-row end-col] [start-row start-col])
      (values [start-row start-col] [end-row end-col])))

(lambda get-range [line-wise?]
  (let [[_ visual-row visual-col] (getpos :v)
        [cursor-row cursor-col] (nvim_win_get_cursor 0)
        v-row0 (- visual-row 1)
        v-col0 (- visual-col 1)
        c-row0 (- cursor-row 1)
        visual-pos (if line-wise? [v-row0 0] [v-row0 v-col0])
        cursor-pos (if line-wise? [c-row0 0] [c-row0 cursor-col])]
    (order-positions visual-pos cursor-pos)))

(lambda match-visual []
  (remove-visual-selection)
  (let [mode (mode)]
    (when (tbl_contains [:v :V] mode)
      (let [line-wise? (= mode :V)
            matches (add-matches highlight-group line-wise?
                                 (get-range line-wise?))]
        (set visual-matches (or matches []))))))

(lambda setup [?user-config]
  (let [user-config (or ?user-config {})]
    (if user-config.match_id
        (set-default-match-id user-config.match_id))
    (if user-config.hl_group
        (nvim_set_hl 0 highlight-group {:link user-config.hl_group}))))

{: setup
 :set_default_match_id set-default-match-id
 :match_visual match-visual
 :remove_visual_selection remove-visual-selection}
