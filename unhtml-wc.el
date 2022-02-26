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
                (delete-between
                    (lambda (find-opener find-closer)
                        ; deletes region between points identified by
                        ; find-opener and find-closer callbacks
                        (goto-char (point-min))
                        (while (funcall find-opener)
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
                                (funcall find-closer)
                                (delete-region start-tag (point))
                            ) ; let*
                        ) ; while
                    ) ; lambda
                ) ; delete-between
                count
            )
            (set-buffer tempbuf)
            (insert-buffer-substring-no-properties curbuf beg end)
            ; Multiline search seems to be troublesome (e.g. slow, stack overflow),
            ; so find opening and closing tags using separate searches.
            (funcall delete-between ; Get rid of commented-out sections.
                (lambda () (search-forward "<!--" nil t))
                (lambda () (search-forward "-->" nil nil))
            )
            (dolist (tag '("head" "style" "script"))
                ; Gobble entire content for these tags, up to and including closing tags
                ; (luckily they don’t nest).
                (funcall delete-between
                    (lambda () (re-search-forward (concat "<" tag "[^>]*>") nil t))
                    (lambda () (re-search-forward (concat "</" tag "[^>]*>") nil nil))
                )
            ) ; dolist
            (goto-char (point-min))
            (perform-replace "<[^>]+>" "" nil t nil)
            (setq count (count-words (point-min) (point-max)))
            (kill-buffer tempbuf)
            (message (format "Words: %d" count))
        ) ; let
    ) ; save-excursion
) ; unhtml-wc
