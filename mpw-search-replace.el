;+
; Search/replace in the style of the old
; Macintosh Programmer’s Workshop.
;-

(defvar last_search_string "" "last-used search string")

(defun search_next (fwd)
    "searches for next/previous occurrence of last_search_string."
    (let ((startpos))
        (unless (equal last_search_string "")
            (cond
                ((use-region-p)
                    (setq startpos
                        (cond
                            (fwd
                                (max (point) (mark))
                            )
                            (t
                                (min (point) (mark))
                            )
                        ) ; cond
                    )
                )
                (t
                    (setq startpos (point))
                )
            ) ; cond
            (deactivate-mark)
            (goto-char startpos) ; so I don't match current selection
            (cond
                (fwd
                    (when (search-forward last_search_string)
                        (set-mark (match-beginning 0))
                    ) ; when
                )
                (t
                    (when (search-backward last_search_string)
                        (set-mark (match-end 0))
                    ) ; when
                )
            ) ; cond
        ) ; unless
    ) ; let
) ; search_next

(global-set-key [?\s-h]
    ; search forward for next occurrence of current selection
    (lambda (selbegin selend)
        (interactive "r")
        (cond
            ((use-region-p)
                (setq last_search_string (buffer-substring selbegin selend))
                (search_next t)
            )
            (t
                (ding)
            )
        ) ; cond
    ) ; lambda
)

(global-set-key [?\s-H]
    ; search backward for next occurrence of current selection
    (lambda (selbegin selend)
        (interactive "r")
        (cond
            ((use-region-p)
                (setq last_search_string (buffer-substring selbegin selend))
                (search_next nil)
            )
            (t
                (ding)
            )
        ) ; cond
    ) ; lambda
)

(global-set-key [?\s-g]
    ; search forward for next occurrence of last_search_string
    (lambda ()
        (interactive)
        (search_next t)
    ) ; lambda
)

(global-set-key [?\s-G]
    ; search backward for next occurrence of last_search_string
    (lambda ()
        (interactive)
        (search_next nil)
    ) ; lambda
)
