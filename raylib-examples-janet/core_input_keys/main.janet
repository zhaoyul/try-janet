(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [core] example - keyboard input")

  (var ball-position @{:x (/ screen-width 2) :y (/ screen-height 2)})

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (when (jay/key-down? :right) (update ball-position :x (fn [x] (+ x 2.0))))
    (when (jay/key-down? :left) (update ball-position :x (fn [x] (- x 2.0))))
    (when (jay/key-down? :up) (update ball-position :y (fn [y] (- y 2.0))))
    (when (jay/key-down? :down) (update ball-position :y (fn [y] (+ y 2.0))))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)
    (jay/draw-text "move the ball with arrow keys" 10 10 20 :dark-gray)
    (jay/draw-circle-v (values ball-position) 50.0 :maroon)
    (jay/end-drawing))

  (jay/close-window))
