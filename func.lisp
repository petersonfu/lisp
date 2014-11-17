;; a function with two optional paramters.
(defun foo (a b &optional c d) (list a b c d))

;; a function with one optional parameter, but with default value.
(defun foo2 (a b &optional (c 10)) (list a b c))

;; default value from required parameter.
(defun rectangle (w &optional (h w)) (format t "~d * ~d.~%" w h))

;; check if parameter is provided.
(defun check (&optional (c 3 c-supplied-p)) (format t "~d ~d. ~%" c c-supplied-p))
