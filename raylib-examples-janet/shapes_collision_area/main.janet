(import jaylib :as jay)
(import string)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [shapes] example - collision area")

  (var box-a @{:x 10.0 :y (- (/ screen-height 2.0) 50) :width 200.0 :height 100.0})
  (var box-a-speed-x 4)

  (var box-b @{:x (- (/ screen-width 2.0) 30) :y (- (/ screen-height 2.0) 30) :width 60.0 :height 60.0})
  (var box-collision @{:x 0 :y 0 :width 0 :height 0})

  (def screen-upper-limit 40)
  (var pause false)
  (var collision false)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (unless pause
      (update box-a :x (fn [x] (+ x box-a-speed-x))))

    (when (or (>= (+ (box-a :x) (box-a :width)) screen-width) (<= (box-a :x) 0))
      (set box-a-speed-x (- box-a-speed-x)))

    (set (box-b :x) (- (jay/get-mouse-x) (/ (box-b :width) 2)))
    (set (box-b :y) (- (jay/get-mouse-y) (/ (box-b :height) 2)))

    (when (>= (+ (box-b :x) (box-b :width)) screen-width) (set (box-b :x) (- screen-width (box-b :width))))
    (when (<= (box-b :x) 0) (set (box-b :x) 0))
    (when (>= (+ (box-b :y) (box-b :height)) screen-height) (set (box-b :y) (- screen-height (box-b :height))))
    (when (<= (box-b :y) screen-upper-limit) (set (box-b :y) screen-upper-limit))

    (set collision (jay/check-collision-recs box-a box-b))
    (if collision (set box-collision (jay/get-collision-rec box-a box-b)))

    (when (jay/is-key-pressed :space) (set pause (not pause)))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-rectangle 0 0 screen-width screen-upper-limit (if collision :red :black))
    (jay/draw-rectangle-rec box-a :gold)
    (jay/draw-rectangle-rec box-b :blue)

    (when collision
      (jay/draw-rectangle-rec box-collision :lime)
      (jay/draw-text "COLLISION!" (- (/ screen-width 2) (/ (jay/measure-text "COLLISION!" 20) 2)) (- (/ screen-upper-limit 2) 10) 20 :black)
      (jay/draw-text (string/format "Collision Area: %d" (* (box-collision :width) (box-collision :height))) (- (/ screen-width 2) 100) (+ screen-upper-limit 10) 20 :black))

    (jay/draw-text "Press SPACE to PAUSE/RESUME" 20 (- screen-height 35) 20 :light-gray)
    (jay/draw-fps 10 10)
    (jay/end-drawing))

  (jay/close-window)))
