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
           (animation :keyframe ("0%" :transform "scale(0.5, 0.5)")
                      :keyframe ("100%" :transform "scale(1, 1)")
                      :delay "0s"
                      :direction "normal"
                      :duration "0.5s"
                      :iteration-count "1"
                      :timeing-function "ease-in")
           (style :height side
                  :width side
                  :margin-left 0
                  :margin-right 0
                  :margin-top 0
                  :margin-bottom 0)
           (on-click (llambda () (unless (@ cell-data :fixed)
                                   (funcall on-focus 
                                            (@ cell-data :group)
                                            (@ cell-data :seq))))))
          (:div ((class "brown-text" 
                        (if (@ cell-data :is-focused)
                            " text-lighten-1"
                            " text-lighten-2"))
                 (style :font-size (if (@ cell-data :is-focused)
                                       "24"
                                       "20")
                        :cursor "pointer"
                        :font-weight "bold"))
                (if (@ cell-data :is-focused)
                    (:span ((animation :keyframe ("0%" :background "rgba(114, 145,156, 0)")
                                       :keyframe ("100%" :background "rgba(114, 145, 156, 1)")
                                       :direction "alternate"
                                       :delay "0.3s"
                                       :duration "0.5s"
                                       :iteration-count "infinite"))
                           (if (= (@ cell-data :digit) 0)
                               "_"
                               (@ cell-data :digit)))
                    (:span () (unless (= (@ cell-data :digit) 0)
                                (@ cell-data :digit))))))))



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

(def-widget-1 digit-button ((digit :attribute)
                            (click-handler :attribute))
  (:a ((href "#")) digit))
  

(def-widget-1 sudoku-board ((cell-side :attribute)
                            (cell-margin :attribute)
                            (group-margin :attribute)
                            ;; states
                            (focused-group :state)
                            (focused-cell :state)
                            (data :state ((@ this generate-puzzle))))
  (labels ((component-did-mount ()
             (key "1, 2, 3, 4, 5, 6, 7, 8, 9" 
                  (@ this handle-key-down)))
           (restart-game ()
             (update-state focused-group null
                           focused-cell null
                           data (funcall (@ this generate-puzzle))))
           (generate-puzzle ()
             (let ((matrix '((0 0 3 8 5 0 7 1 0)
                             (8 0 0 0 0 9 3 0 0)
                             (0 0 9 0 0 2 0 0 0)
                             (7 0 0 9 0 3 0 5 4)
                             (9 0 5 0 6 0 8 0 7)
                             (1 2 0 5 0 8 0 0 3)
                             (0 0 0 2 0 0 4 0 0)
                             (0 0 7 6 0 0 0 0 1)
                             (0 1 2 0 8 5 9 0 0))))
               (map (lambda (group)
                      (map (lambda (seq)
                             (let ((y (+ (* (floor group 3) 3) (floor seq 3)))
                                   (x (+ (* (rem group 3) 3) (rem seq 3))))
                               (create :group group
                                       :seq seq
                                       :is-focused false
                                       :fixed (not (= (aref matrix y x) 0))
                                       :digit (aref matrix y x))))
                           '(0 1 2 3 4 5 6 7 8)))
                      '(0 1 2 3 4 5 6 7 8))))
           (check-duplication (digits)
             (let ((hash '(0 0 0 0 0 0 0 0 0))
                   (pass true))
               (loop for digit in digits
                  do (incf (aref hash (1- digit))))
               (loop for i from 0 to 8
                  do (when (not (= (aref hash i) 1))
                       (setf pass false)
                       (break)))
               pass))
           (get-row (data i)
             (map (lambda (j)
                    (@ (aref data
                             (+ (* (floor i 3) 3) (floor j 3))
                             (+ (* (rem i 3) 3) (rem j 3)))
                       :digit))
                  '(0 1 2 3 4 5 6 7 8)))
           (get-col (data j)
             (map (lambda (i)
                    (@ (aref data
                             (+ (* (rem i 3) 3) (rem j 3))
                             (+ (* (floor i 3) 3) (floor j 3)))
                       :digit))
                  '(0 1 2 3 4 5 6 7 8)))
           (get-group (data group)
             (map (lambda (x) (@ x :digit))
                  (aref data group)))
           (check-board (data)
             (let ((pass true))
               ;; Row Check
               (loop for i from 0 to 8
                  do (when (not (funcall (@ this check-duplication)
                                         (funcall (@ this get-row) data i)))
                       (setf pass false)
                       (break)))
               (trace pass)
               (when (not pass)
                 (return false))
               ;; Column Check
               (loop for i from 0 to 8
                  do (when (not (funcall (@ this check-duplication)
                                         (funcall (@ this get-col) data i)))
                       (setf pass false)
                       (break)))
               (when (not pass)
                 (return false))
               ;; Group Check
               (loop for i from 0 to 8
                  do (when (not (funcall (@ this check-duplication)
                                         (funcall (@ this get-group) data i)))
                       (setf pass false)
                       (break)))
               pass))
           (handle-key-down (event handler)
             (when (:state focused-cell)
               (let ((new-data (funcall (@ (:state data) slice))))
                 (with-slots (:is-focused :digit) 
                     (aref new-data 
                           (@ (:state focused-cell) :group)
                           (@ (:state focused-cell) :seq))
                   (setf :is-focused false)
                   (setf :digit (@ handler shortcut)))
                 (when (funcall (@ this check-board) new-data)
                   (loop for i from 0 to 8
                      do (loop for j from 0 to 8
                            do (setf (@ (aref new-data i j) :fixed)
                                     true))))
                 (update-state focused-cell null
                               data new-data))))
           (update-focused-cell (group seq)
             (let ((new-data (funcall (@ (:state data) slice)))
                   (new-focused-cell (create :group group
                                             :seq seq)))
               (when (:state focused-cell)
                 (setf (aref new-data 
                             (@ (:state focused-cell) :group)
                             (@ (:state focused-cell) :seq)
                             :is-focused)
                       false))
               (if (and (:state focused-cell)
                        (= (@ (:state focused-cell) :group) group)
                        (= (@ (:state focused-cell) :seq) seq))
                   (setf new-focused-cell null)
                   (setf (@ (aref new-data group seq) :is-focused)
                         true))
               (update-state focused-cell new-focused-cell
                             data new-data))))
    (:div ((class "row"))
          (:div ((class "col s12 m7"))
                (:div ((class "card z-depth-2"))
                      (:div ((class "card-content yellow lighten-5"))
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
                                            '(0 1 2 3 4 5 6 7 8) :this this)))
                      (:div ((class "card-action amber lighten-4"))
                            (:a ((href "#")
                                 (on-click (@ this restart-game)))
                                "Restart")))))))


             

(def-app sudoku-demo ()
  :title "Sudoku Demo"
  :uri "/sudoku"
  :port 12800
  :includes ("https://cdnjs.cloudflare.com/ajax/libs/materialize/0.96.1/css/materialize.min.css"
             "https://cdnjs.cloudflare.com/ajax/libs/materialize/0.96.1/js/materialize.min.js"
             "https://cdnjs.cloudflare.com/ajax/libs/keymaster/1.6.1/keymaster.min.js")
  :widget (:sudoku-board ((cell-side 50)
                          (cell-margin 3)
                          (group-margin 4))))


