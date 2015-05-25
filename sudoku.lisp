;;;; sudoku.lisp

(defpackage #:breakds.sudoku-demo
  (:nicknames #:sudoku-demo)
  (:use #:cl
        #:ps
        #:realispic))

(in-package #:breakds.sudoku-demo)

(def-widget-1 grid-3x3 ()
  (:table ((style :display "flex"))
          (:tr ()
               (map (lambda (child)
                      (:td ((style :padding 0)) child))
                    (:children 0 1 2)))
          (:tr ()
               (map (lambda (child)
                      (:td ((style :padding 0)) child))
                    (:children 3 4 5)))
          (:tr ()
               (map (lambda (child)
                      (:td ((style :padding 0)) child))
                    (:children 6 7 8)))))



(def-widget-1 sudoku-cell ((digit :attribute)
			   (cell-side :attribute)
                           (cell-margin :attribute))
  (:div ((class "card-panel blue lighten-2 valign-wrapper z-depth-1")
         (style  :height cell-side
                 :width cell-side
                 :margin-left cell-margin
                 :margin-right cell-margin
                 :margin-top cell-margin
                 :margin-bottom cell-margin))
	(:div ((class "white-text")
               (style :font-size "20"))
              digit)))


(def-widget-1 sudoku-group ((digits :attribute)
			    (cell-side :attribute)
			    (cell-margin :attribute))
  (:grid-3x3 ()
             (map (lambda (x) 
                    (:sudoku-cell ((digit x)
                                   (cell-margin cell-margin)
                                   (cell-side cell-side))))
                  digits :this this)))

(def-app sudoku-demo ()
  :title "Sudoku Demo"
  :uri "/sudoku"
  :port 12800
  :includes ("https://cdnjs.cloudflare.com/ajax/libs/materialize/0.96.1/css/materialize.min.css"
	     "https://cdnjs.cloudflare.com/ajax/libs/materialize/0.96.1/js/materialize.min.js")
  :widget (:sudoku-group ((digits (array 1 2 5 4 3 9 8 7 6))
			  (cell-side 50)
                          (cell-margin 4))))


