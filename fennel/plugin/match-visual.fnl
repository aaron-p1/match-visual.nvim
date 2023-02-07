(local {:api {: nvim_create_autocmd : nvim_create_augroup}} vim)

(local {: match_visual : remove_visual_selection} (require :match-visual))

(let [group (nvim_create_augroup :MatchVisual {:clear true})]
  (nvim_create_autocmd :CursorMoved {: group :callback match_visual})
  (nvim_create_autocmd :ModeChanged
                       {: group :pattern "*:[vV]" :callback match_visual})
  (nvim_create_autocmd :ModeChanged
                       {: group
                        :pattern "[vV]:*"
                        :callback remove_visual_selection}))
