(defvar *db* nil)
(defun dump-db ()
  (dolist (cd *db*)
    (format t "~{~a:~10t~a~%~}~%" cd)))
(defun dump-db-2 ()
  (format t "~{~{~a:~10t~a~%~}~%~}~%" *db*))

(defun make-cd (title artist rating ripped)
  (list
    :title title
    :artist artist
    :rating rating
    :ripped ripped))
(defun add-record (cd) (push cd *db*))

(defun prompt-read (prompt)
  (format *query-io* "~a: " prompt)
  (force-output *query-io*)
  (read-line *query-io*))
(defun prompt-for-cd ()
  (make-cd
    (prompt-read "title")
    (prompt-read "artist")
    (or (parse-integer (prompt-read "rating") :junk-allowed t) 0)
    (y-or-n-p "ripped [y/n]")))
(defun add-cds ()
  (loop (add-record (prompt-for-cd))
    (if (not (y-or-n-p "Another? [y/n]: ")) (return))))

(defun save-db (filename)
  (with-open-file
    (out filename :direction :output :if-exists :supersede)
    (with-standard-io-syntax
      (print *db* out))))
(defun load-db (filename)
  (with-open-file
    (in filename)
    (with-standard-io-syntax
      (setf *db* (read in)))))

(defun select-by-artist (artist)
  (remove-if-not
    #'(lambda (cd) (equal (getf cd :artist) artist))
    *db*))
(defun select (selector-fun)
  (remove-if-not selector-fun *db*))
(defun artist-selector (artist)
  #'(lambda (cd) (equal (getf cd :artist) artist)))
; (select (artist-selector "Dixi"))
(defun where (&key title artist rating (ripped nil ripped-p))
  #'(lambda (cd)
    (and
      (if artist
        (equal (getf cd :artist) artist)
        t)
      (if title
        (equal (getf cd :title) title)
        t)
      (if rating
        (equal (getf cd :rating) rating)
        t)
      (if ripped-p
        (equal (getf cd :ripped) ripped)
        t)
      )))
; (select (where :artist "Dixi"))

(defun update (selector-fun &key title artist rating (ripped nil ripped-p))
  (setf *db*
    (mapcar
      #'(lambda (row)
          (when (funcall selector-fun row)
            (if title (setf (getf row :title) title))
            (if artist (setf (getf row :artist) artist))
            (if rating (setf (getf row :rating) rating))
            (if ripped-p (setf (getf row :ripped) ripped)))
          row)
      *db*)))
; (update (where :artist "aaa") :rating 11)

