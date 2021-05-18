;+
; For convenient rearrangement of accumulated mail messages.
;
; Note “mstr” macro is defined in main dotemacs file.
;-

(defun select_mail_message ()
    (mstr
        "selects the whole of the current message (from previous formfeed"
        " up to before next formfeed) in a mail collection file."
    )
    (interactive)
    (deactivate-mark)
    (search-backward "\f" nil 1)
    (set-mark (point))
    (cond
        ((search-forward "\f" nil 1 2)
            (backward-char)
        )
    ) ; cond
) ; select_mail_message

(global-set-key [?\C-c ?m] 'select_mail_message)
