;+
; Do a word count of a selection of HTML text, excluding markup.
;-

(defun unhtml-wc (beg end)
    "does a word count of a selection of HTML text, excluding markup."
    (interactive "r")
    (save-excursion
        (let
            (
                (curbuf (current-buffer))
                (tempbuf (generate-new-buffer "wc-temp"))
                count
            )
            (set-buffer tempbuf)
            (insert-buffer-substring-no-properties curbuf beg end)
            (dolist (tag '("head" "style" "script"))
                ; Gobble entire content for these tags, up to and including closing tags
                ; (luckily they don’t nest).
                ; Multiline search seems to be troublesome (e.g. slow, stack overflow),
                ; so find opening and closing tags using separate searches.
                (goto-char (point-min))
                (while (re-search-forward (concat "<" tag "[^>]*>") nil t)
                    (let*
                        (
                            (end-tag (point))
                            (start-tag
                                (progn
                                    (search-backward "<" nil nil)
                                    (point)
                                ) ; progn
                            )
                        )
                        (goto-char end-tag)
                        (re-search-forward (concat "</" tag "[^>]*>") nil nil)
                        (delete-region start-tag (point))
                    ) ; let*
                ) ; while
            ) ; dolist
            (goto-char (point-min))
            (perform-replace "<[^>]+>" "" nil t nil)
            (setq count (count-words (point-min) (point-max)))
            (kill-buffer tempbuf)
            (message (format "Words: %d" count))
        ) ; let
    ) ; save-excursion
) ; unhtml-wc
