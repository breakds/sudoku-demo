;;;; sudoku.lisp

(defpackage #:breakds.sudoku-demo
  (:nicknames #:sudoku-demo)
  (:use #:cl
        #:ps
        #:realispic))

(in-package #:breakds.sudoku-demo)

(def-widget-1 sudoku-cell ((number :state 1))
  (let ((x 12))
    (:div ((style :width 10
                  :height 20))
          (:a ((href "about/")))
          (:div () (local-state number)))))

;; (def-realispic-app (sudoku ()
;;                     :title "Sudoku"
;;                     :libs ("https://cdnjs.cloudflare.com/ajax/libs/react/0.13.2/react.min.js"
;;                            "https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js")
;;                     :port 16390)
;;   (:sudoku-board))

