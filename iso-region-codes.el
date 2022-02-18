;+
; Generating “region indicator symbols”. That is to say, national/regional flags.
; These are present in OpenType fonts such as Noto Color Emoji, and will be
; substituted for symbol pairs according to the codes defined in ISO-3166.
;-

(defun convert-to-region-codes (beg end)
    "converts alphabetic characters in the selection to “region indicator symbols”."
    (interactive "*r")
    (unless (use-region-p)
        (ding)
        (keyboard-quit)
    ) ; unless
    (let
        (
            deactivate-mark
            (intext (delete-and-extract-region beg end))
            c
        )
        (dotimes (i (- end beg))
            (setq c (elt intext i))
            (cond
                ((and (>= c ?A) (<= c ?Z))
                    (setq c (+ (- c ?A) #x1F1E6))
                )
                ((and (>= c ?a) (<= c ?z))
                    (setq c (+ (- c ?a) #x1F1E6))
                )
            ) ; cond
            (insert-char c)
        ) ; dotimes
    ) ; let
) ; convert-to-region-codes
