;;;; sudoku.lisp

(defpackage #:breakds.sudoku-demo
  (:nicknames #:sudoku-demo)
  (:use #:cl
        #:ps
        #:realispic))

(in-package #:breakds.sudoku-demo)

(def-widget-1 sudoku-cell ((digit :attribute)
			   (cell-side :attribute))
  (:div ((class "card-panel blue lighten-2 valign-wrapper z-depth-2 col s4")
	 (style :height cell-side
		:margin-top 0
		:margin-bottom 0))
	(:span ((class "white-text valign")) digit)))

(def-widget-1 sudoku-group ((digits :attribute)
			    (cell-side :attribute)
			    (half-margin :attribute))
  (:div ((style :width (* 3 cell-side)))
  	(:div ((class "row")
	       (style :margin-top 0
		      :margin-bottom 5))
  	      (:sudoku-cell ((digit (aref digits 0))
			     (cell-side cell-side)))
  	      (:sudoku-cell ((digit (aref digits 1))
			     (cell-side cell-side)))
  	      (:sudoku-cell ((digit (aref digits 2))
			     (cell-side cell-side))))
  	(:div ((class "row")
	       (style :margin-top 0
		      :margin-bottom 5))
	      (:sudoku-cell ((digit (aref digits 3))
			     (cell-side cell-side)))
	      (:sudoku-cell ((digit (aref digits 4))
			     (cell-side cell-side)))
	      (:sudoku-cell ((digit (aref digits 5))
			     (cell-side cell-side))))
  	(:div ((class "row")
	       (style :margin-top 0
		      :margin-bottom 5))
	      (:sudoku-cell ((digit (aref digits 3))
			     (cell-side cell-side)))
	      (:sudoku-cell ((digit (aref digits 4))
			     (cell-side cell-side)))
	      (:sudoku-cell ((digit (aref digits 5))
			     (cell-side cell-side))))))
	

(def-app sudoku-demo ()
  :title "Sudoku Demo"
  :uri "/sudoku"
  :port 12800
  :includes ("https://cdnjs.cloudflare.com/ajax/libs/materialize/0.96.1/css/materialize.min.css"
	     "https://cdnjs.cloudflare.com/ajax/libs/materialize/0.96.1/js/materialize.min.js")
  :widget (:sudoku-group ((digits (array 1 2 5 4 3 9 8 7 6))
			  (cell-side 40))))


