;;;; sudoku-demo.asd

(asdf:defsystem #:sudoku-demo
    :serial t
    :depends-on (#:basicl
                 #:parenscript
                 #:realispic)
    :components ((:file "sudoku")))
