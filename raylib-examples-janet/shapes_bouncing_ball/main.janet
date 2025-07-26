(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [shapes] example - bouncing ball")

  (var ball-position @{:x (/ screen-width 2.0) :y (/ screen-height 2.0)})
  (var ball-speed @{:x 5.0 :y 4.0})
  (var ball-radius 20)

  (var pause false)
  (var frames-counter 0)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (when (jay/is-key-pressed :space) (set pause (not pause)))

    (unless pause
      (update ball-position :x (fn [x] (+ x (ball-speed :x))))
      (update ball-position :y (fn [y] (+ y (ball-speed :y))))

      (when (or (>= (+ (ball-position :x) ball-radius) screen-width) (<= (- (ball-position :x) ball-radius) 0))
        (update ball-speed :x #(- %)))
      (when (or (>= (+ (ball-position :y) ball-radius) screen-height) (<= (- (ball-position :y) ball-radius) 0))
        (update ball-speed :y #(- %))))

    (when pause (set frames-counter (inc frames-counter)))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-circle-v ball-position ball-radius :maroon)
    (jay/draw-text "PRESS SPACE to PAUSE BALL MOVEMENT" 10 10 20 :light-gray)

    (when (and pause (even? (// frames-counter 30)))
      (jay/draw-text "PAUSED" 350 200 30 :gray))

    (jay/draw-fps 10 430)
    (jay/end-drawing))

  (jay/close-window)))
