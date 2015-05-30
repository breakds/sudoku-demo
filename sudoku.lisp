;;;; sudoku.lisp

(defpackage #:breakds.sudoku-demo
  (:nicknames #:sudoku-demo)
  (:use #:cl
        #:ps
        #:realispic))

(in-package #:breakds.sudoku-demo)

(def-widget-1 grid-3x3 ((cell-margin :attribute)
                        (on-focus :attribute))
  (:table ((style :display "flex")
           (on-mouse-enter on-focus))
          (:tr ()
               (map (lambda (child)
                      (:td ((style :padding cell-margin))
                           child))
                    (:children 0 1 2) :this this))
          (:tr ()
               (map (lambda (child)
                      (:td ((style :padding cell-margin))
                           child))
                    (:children 3 4 5) :this this))
          (:tr ()
               (map (lambda (child)
                      (:td ((style :padding cell-margin))
                           child))
                    (:children 6 7 8) :this this))))


(def-widget-1 sudoku-cell ((cell-data :attribute)
			   (side :attribute)
                           (depth :attribute)
                           (on-focus :attribute))
  (labels ((component-will-update ()
             nil))
    (:div ((class "card-panel" "valign-wrapper" "go-appear"
                  ;; pick color based on whether it is fixed or not.
                  (if (@ cell-data :fixed) "orange" "teal")
                  (if (@ cell-data :is-focused)
                      "lighten-3"
                      "lighten-4")
                  (if (@ cell-data :is-focused)
                      "z-depth-3" ""))
           (animation :keyframe ("0%" :opacity 0)
                      :keyframe ("100%" :opacity 1)
                      :delay "0s"
                      :direction "normal"
                      :duration "0.5s"
                      :fill-mode "haha"
                      :iteration-count "1"
                      :timeing-function "ease-in")
           (style :height (if (@ cell-data :is-focused)
                              (* side 1.05)
                              side)
                  :width (if (@ cell-data :is-focused)
                             (* side 1.05)
                             side)
                  :margin-left 0
                  :margin-right 0
                  :margin-top 0
                  :margin-bottom 0)
           (on-click (llambda () (unless (@ cell-data :fixed)
                                   (funcall on-focus 
                                            (@ cell-data :group)
                                            (@ cell-data :seq))))))
          (:span ((class (+ "brown-text" 
                            (if (@ cell-data :is-focused)
                                " text-lighten-1"
                                " text-lighten-2")))
                  (style :font-size (if (@ cell-data :is-focused)
                                        "24"
                                        "20")
                         :cursor "pointer"
                         :font-weight "bold"))
                 (@ cell-data :digit)))))



(def-widget-1 sudoku-group ((group-data :attribute)
			    (cell-side :attribute)
                            (cell-margin :attribute)
                            (on-focus :attribute)
                            (on-cell-focus :attribute))
  (:grid-3x3 ((cell-margin cell-margin)
              (on-focus on-focus))
             (map (lambda (x) 
                    (:sudoku-cell ((cell-data x)
                                   (key (+ (aref x :group)
                                           (aref x :seq)
                                           (aref x :digit)))
                                   (on-focus on-cell-focus)
                                   (side cell-side))))
                  group-data :this this)))

(def-widget-1 sudoku-board ((cell-side :attribute)
                            (cell-margin :attribute)
                            (group-margin :attribute)
                            (focused-group :state)
                            (focused-cell :state)
                            (data :state (map (lambda (x)
                                                (map (lambda (y)
                                                       (create :group x
                                                               :seq y
                                                               :is-focused false
                                                               :fixed (< ((@ *math random)) 0.5)
                                                               :digit (1+ (rand-int 9))))
                                                     '(0 1 2 3 4 5 6 7 8)))
                                              '(0 1 2 3 4 5 6 7 8))))
  (labels ((update-focused-cell (group seq)
             (let ((new-data (funcall (@ (:state data) slice))))
               (when (:state focused-cell)
                 (setf (aref new-data 
                             (@ (:state focused-cell) :group)
                             (@ (:state focused-cell) :seq)
                             :is-focused)
                       false))
               (setf (@ (aref new-data group seq) :is-focused)
                     true)
               (setf (@ (aref new-data group seq) :digit)
                     (1+ (rand-int 9)))
               (update-state focused-cell (create :group group
                                                  :seq seq)
                             data new-data))))
    (:div ()
          (:grid-3x3 ((cell-margin group-margin))
                     (map (lambda (x)
                            (:sudoku-group ((group-data (aref (:state data) x))
                                            (on-focus (llambda ()
                                                               (update-state focused-group x)))
                                            (on-cell-focus (@ this update-focused-cell))
                                            (cell-margin (if (= x (:state focused-group))
                                                             (- cell-margin 1)
                                                             cell-margin))
                                            (cell-side cell-side))))
                          '(0 1 2 3 4 5 6 7 8) :this this)))))
             

(def-app sudoku-demo ()
  :title "Sudoku Demo"
  :uri "/sudoku"
  :port 12800
  :includes ("https://cdnjs.cloudflare.com/ajax/libs/materialize/0.96.1/css/materialize.min.css"
             "https://cdnjs.cloudflare.com/ajax/libs/materialize/0.96.1/js/materialize.min.js")
  :widget (:sudoku-board ((cell-side 50)
                          (cell-margin 3)
                          (group-margin 4))))


